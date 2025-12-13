struct UserProfileDTO: Codable {
    let fullName: String?
    let email: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case email
        case bio
    }
}
