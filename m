Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793880900;
	b=JKkPj7Gqn5vQHPDzQpFwH1ghGPS1fFFBDRPAcfIta8N/Ll/XQi+rp21OQE4UnXsl6XYu
	 Mojn0q4/yTFc1bVug8OGeeN6AdUiWs1O2iiDgyy1QUY2Ua5PBeM2YPyNBil9dMHMhX4iK
	 AsIyFcOUpZO1UR57Zfoj/T++bewJrwFd9BttSfS3kDJTpqrVSP6QJOMbWlv6WNT9bMrcF
	 CtSLT2p7xPZfkUPmbAzgf5lnnMjN3/kNmj/bwGyagPcN2Swn9UovW3IitZwDZygwI/iou
	 ShfikyGY45jwJOH9YqmEf12LXp9DmpAf7y83O3ijWnkpjD83Zvk/hb6s2yLB3tVGBkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793880900;
	h=Received:DKIM-Signature:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=nzMu0LvOVRk4gYucc352LR/eb8z9dwYmb9Fy/SL8Y2Y=;
	b=HOECpvWXukksHu1PkuHndt+0tvOHWqm8G5cycCtuhCFbpJEr4B2030wYp2s+2D1dpgzH
	 BEv5bTDOF8UaeGpK7U9QXx2xZUX1Ry/GljJnr9wLa9h8b2jYk42vRj20rnz9AwwP5j/vQ
	 4UIC9Nf1XYilDAX1uXVjlbliqMGAbt1pJOxL+HJGeDn2i2XaZ+EZZ30GnqRbFCJwo0ntz
	 Aj14Ppdqf7lW7iJIqeUT5QWNVyVIWVFVzw6gr6Pgi7xzrF3eJYu45K9qkR9pj0JCbZgaL
	 BWIUWAd2k796/QlP97zV5Qda1yqSGCV2GsBPFjxb2aJdo28G4BrBOm6IXkRrPpD3k8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iSvqxE5I;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B54606A32D;
	Thu,  5 Nov 2026 12:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iSvqxE5I
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2261F000C1;
	Thu,  5 Nov 2026 12:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880899;
	bh=nzMu0LvOVRk4gYucc352LR/eb8z9dwYmb9Fy/SL8Y2Y=;
	h=From:Subject:Date:To:Cc;
	b=iSvqxE5IYBIU+Y5GCKJKuOH3flf9F9UfGQLljxlsMA8++OkLyi3S/Ogy4ufmmnV/6
	 yMWwJ2BahIMvDBL3aUnVGSvkKZ6kh5mO9cmgITUP6HESkzceUHAU6dOHiQqIf7BSaP
	 MO/2gtDLNoBa4WO51NS8IJN9rbblu59vjlGDRlAYfvA+H6OaVG37jndQPsyBAuQW5o
	 6kyMPS+vUUlSLoi3lfrvUyPZ6trmts5vQfe6mqWRqe4tI8q1+0fRwG6AS2WWPn5NUX
	 XkKBYZVOHHrBFFmWZVVOtO7EWZlelUoGhVQKlRURuvcCCrY4cU5RSZu/rRVuD++nQJ
	 xPMhv+qfaBf0w==
From: Mark Brown <broonie@kernel.org>
Subject: [PATCH v10 0/3] KVM: selftests: arm64: Improve diagnostics from
 set_id_regs
Date: Thu, 05 Nov 2026 11:47:18 +0000
Message-Id: <20261105-kvm-arm64-set-id-regs-aarch64-v10-0-d5a6aba69d19@kernel.org>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAMhs7GoC/4XSS04DMQwG4KtUWRNke/JkxT0QiyR12lFpizLVC
 FT17mQqYEBZZOnf0mc7ylVMXEaexNPmKgrP4zSeT7VAeNiItA+nHctxWwNBQBqBnDzMRxnK0Sg
 58aU2ZeHdJEMoaV8zjtFab7wCTKIa74Xz+HEf8PJa6/04Xc7l8z5vxiX9lgfoyDNKkN5khi1Ft
 I6fD1xO/PZ4Ljux0DOtHKLqcVQ5YykTqqww5oYbVo7Q97ihcjEHZRWngdA1nPrhDCCYHqcqlyx
 npTWGHIeG0ys3oO1xunLBQKbotWGihjMrZ/vHmspZUuRs1hmhPdaunAfscXbhIhgdIW6DDw3n/
 nDU3c5VTrsQIlOiHFLD+V8O68frcX55uzhQTNbn4P9zt9vtC1JoiTNEAwAA
X-Change-ID: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c
To: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
 Oliver Upton <oupton@kernel.org>
Cc: Ben Horgan <ben.horgan@arm.com>, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Mark Brown <broonie@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 Sebastian Ott <sebott@redhat.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3029; i=broonie@kernel.org;
 h=from:subject:message-id; bh=7s/Hv3YNIBJTtux/ZgPX0J101dWs/N9Z8C+esxNBSM0=;
 b=owGbwMvMwCWm/754w+YLFp2Mp9WSGLLeFNtPmJ2W+sjbcufOu6F6kQ1vF1h89O3X7deL6dHYl
 n6hPmhyRykLgxgXg6yYIktcFvfL+pLXa/gOLmyDmcPKBDKEgYtTACbyzpaRYenmyd7rz0zNuDfr
 oOX96Hv71mvwFETs599TumX5CzddxyUM/4smiXkbP7x36k9TZ7CInoS3dzNPj59zY3r45oDGx8J
 pHAA=
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

While debugging issues related to aarch64 only systems I ran into
speedbumps due to the lack of detail in the results reported when the
guest register read and reset value preservation tests were run, they
generated an immediately fatal assert without indicating which register
was being tested. Update these tests to non-fatally report a standard
kselftest result per register, making it much easier to see what the
problem being reported is.

A similar issue exists with the validation of the individual bitfields
in registers due to the use of immediately fatal asserts. Update those
asserts to be standard kselftest reports.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
Changes in v10:
- Use __vcpu_set_reg() when testing valid writes to avoid asserts.
- Use local variable for reg_id more.
- Link to v9: https://patch.msgid.link/20261103-kvm-arm64-set-id-regs-aarch64-v9-0-ab32bc79fa9c@kernel.org

Changes in v9:
- Rebase onto v7.4-rc1.
- Link to v8: https://patch.msgid.link/20260929-kvm-arm64-set-id-regs-aarch64-v8-0-58aabe2c2fac@kernel.org

Changes in v8:
- Convert another assert.
- Link to v7: https://patch.msgid.link/20260901-kvm-arm64-set-id-regs-aarch64-v7-0-7b065b0bda9a@kernel.org

Changes in v7:
- Rebase onto v7.3-rc1.
- Link to v6: https://patch.msgid.link/20260719-kvm-arm64-set-id-regs-aarch64-v6-0-724287f5f108@kernel.org

Changes in v6:
- Rebase onto v7.2-rc3.
- Drop changes to handling of aarch32 related registers on 64 bit only
  systems, an in kernel solution is preferred for those.
- Use a define to count the non-test_regs registers.
- Link to v5: https://patch.msgid.link/20260317-kvm-arm64-set-id-regs-aarch64-v5-0-a60f2b956e22@kernel.org

Changes in v5:
- Rebase onto v7.0-rc1.
- Link to v4: https://patch.msgid.link/20260106-kvm-arm64-set-id-regs-aarch64-v4-0-c7ef4551afb3@kernel.org

Changes in v4:
- Correct check for 32 bit ID registers.
- Link to v3: https://patch.msgid.link/20251219-kvm-arm64-set-id-regs-aarch64-v3-0-bfa474ec3218@kernel.org

Changes in v3:
- Rebase onto v6.19-rc1.
- Link to v2: https://patch.msgid.link/20251114-kvm-arm64-set-id-regs-aarch64-v2-0-672f214f41bf@kernel.org

Changes in v2:
- Add a fix for spurious failures with 64 bit only guests.
- Link to v1: https://patch.msgid.link/20251030-kvm-arm64-set-id-regs-aarch64-v1-0-96fe0d2b178e@kernel.org

---
Mark Brown (3):
      KVM: selftests: arm64: Report set_id_reg reads of test registers as tests
      KVM: selftests: arm64: Report register reset tests individually
      KVM: selftests: arm64: Make set_id_regs bitfield validity checks non-fatal

 tools/testing/selftests/kvm/arm64/set_id_regs.c | 152 +++++++++++++++++-------
 1 file changed, 111 insertions(+), 41 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm master
change-id: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c

Best regards,
--  
Mark Brown <broonie@kernel.org>

