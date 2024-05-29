Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC6E181BAA
	for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 12:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716984893; cv=none; b=jP8ULwGepX1Xk5/q806HzXPWyxxTwX/ieGghp78+/JIdaGlNVHbfyf6C1WmZwiPAJxDlRzaV3dUABSYtVWN32WK8BkYhyGNjK3+aDCYOBYX0R8mkdwqbb/9/iFdSvHT6Nn6X5CdVQsbN2m9usF96e35+zTq0zCjrltiEXUmUTK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716984893; c=relaxed/simple;
	bh=WMM5G0N4qiU3hKk5YjCYS3EFswJ4zM88IW8Mlp+DlzQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QMTYOUVAR9R6q0VXKyw+ZY2IBubZIvd2QzTF6Tuo5CCMucG14Ar1oR7zmjPoRU8Jd0fkAo7NHQ+VJ0xUhfsCdnsL6rKSOfZ39rHnXqkPA617TvaMNjoVXwgfFKTR2hn1qUU2gIVypHMIdfLn0JDW1cXkx1WLlF14n26RtTEkZ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hlozvC7y; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--ptosi.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hlozvC7y"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-57865139b7dso1201618a12.1
        for <kvmarm@lists.linux.dev>; Wed, 29 May 2024 05:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716984890; x=1717589690; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8CshqLHlWDJc+sAJS8Y64z59WBwvQ7VfO+S7UGCs2ew=;
        b=hlozvC7yRhOW+7GvZa0TzDRoULrhGqM9SbRiJF0qqv/5oSKM7fCvsmd9fhjFj3b5nI
         uPykHHdi2ygkcwiXqAg8xbubtncbXO+rIgFQThcGA0WEC7iKrCAFyAjfDbLbMI0kjXuB
         WZgsmrbpeWZm/onByiz2wrmG4duEtHsi4LltN7eAsRr+MP1KGj/Ip2C6L0diADX0qLIG
         aw8UiFKTi8r9GKdSQJR6ixhXAHZoR9qZFKC7ppYhvqWhxzs1BdkCojpLwLwgg7Ux/n3W
         KWso/JC46ajkxKIAiLjtwr8PmUc0rNyU1yaks28y36vrNdfvipoD+bMOWumLfLbXJSOZ
         cadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716984890; x=1717589690;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8CshqLHlWDJc+sAJS8Y64z59WBwvQ7VfO+S7UGCs2ew=;
        b=VsZtLj7fGJSCJ8DUkwLw2M22D6QG75kid+U9dW/5DePraPeuLyrnhO6k1lAQ2uA5E+
         TheU71648MgftcMNoPJBXgmZeuh/BN916k2yQWf81cWbZilBU82X4ehGAwx4SKqtw/f/
         RhKrA7lFL/AWhmt3ZkV9Pdq0x12UX86oLu07sFcK7Rls5IIZzf+USN6isbnbiMMZKHxw
         TMWnUNlM0v6OxAqXnuz2IQskSFuIBkR2+/jUus+w3HyI7NIGsKSPxo2cohwce2QtsuwY
         Jv6BXqYWBN1F8mCkWowSe5Vo2k64mhs8y5vVJQ1JCTDXXKtKJopgzBfWXBlNBSn43JSy
         esmA==
X-Gm-Message-State: AOJu0YxbRTiJMbaVq5NiTBwc9RWuV06TXw0W+rgD/FMawQcrWrIRWB0H
	gDN2CGHbCp3+MPr2sKp8zs1u2kTOWylymAs+8GP7eNViVKngDxz4yOMzKz9f06+2P0FVQrYr21s
	1jd7bPS0rTrjoTh1G9LaLY15/L/QAj9wLowj2Na/GgH/I1s1YtbIyoPwbuiXVXVa1IDY/Ucgf9E
	12YTj2+Okcn7mBFS3+OkS6I5NhHpw=
X-Google-Smtp-Source: AGHT+IE8phGpuuq3k7TrjskcqmK2dPZ5kpLf85cdSWAkkY4MTdPq3mbXxQAEr7SdzcRt27FdzPre1IagDw==
X-Received: from ptosi.c.googlers.com ([fda3:e722:ac3:cc00:31:98fb:c0a8:11ec])
 (user=ptosi job=sendgmr) by 2002:a05:6402:35b:b0:578:60a0:9995 with SMTP id
 4fb4d7f45d1cf-57a041685b6mr2744a12.3.1716984890481; Wed, 29 May 2024 05:14:50
 -0700 (PDT)
Date: Wed, 29 May 2024 13:12:15 +0100
In-Reply-To: <20240529121251.1993135-1-ptosi@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240529121251.1993135-1-ptosi@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529121251.1993135-10-ptosi@google.com>
Subject: [PATCH v4 09/13] KVM: arm64: Introduce print_nvhe_hyp_panic helper
From: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	kvm@vger.kernel.org
Cc: "=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?=" <ptosi@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add a helper to display a panic banner soon to also be used for kCFI
failures, to ensure that we remain consistent.

Signed-off-by: Pierre-Cl=C3=A9ment Tosi <ptosi@google.com>
---
 arch/arm64/kvm/handle_exit.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d41447193e13..b3d6657a259d 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -411,6 +411,12 @@ void handle_exit_early(struct kvm_vcpu *vcpu, int exce=
ption_index)
 		kvm_handle_guest_serror(vcpu, kvm_vcpu_get_esr(vcpu));
 }
=20
+static void print_nvhe_hyp_panic(const char *name, u64 panic_addr)
+{
+	kvm_err("nVHE hyp %s at: [<%016llx>] %pB!\n", name, panic_addr,
+		(void *)(panic_addr + kaslr_offset()));
+}
+
 void __noreturn __cold nvhe_hyp_panic_handler(u64 esr, u64 spsr,
 					      u64 elr_virt, u64 elr_phys,
 					      u64 par, uintptr_t vcpu,
@@ -439,11 +445,9 @@ void __noreturn __cold nvhe_hyp_panic_handler(u64 esr,=
 u64 spsr,
 		if (file)
 			kvm_err("nVHE hyp BUG at: %s:%u!\n", file, line);
 		else
-			kvm_err("nVHE hyp BUG at: [<%016llx>] %pB!\n", panic_addr,
-					(void *)(panic_addr + kaslr_offset()));
+			print_nvhe_hyp_panic("BUG", panic_addr);
 	} else {
-		kvm_err("nVHE hyp panic at: [<%016llx>] %pB!\n", panic_addr,
-				(void *)(panic_addr + kaslr_offset()));
+		print_nvhe_hyp_panic("panic", panic_addr);
 	}
=20
 	/* Dump the nVHE hypervisor backtrace */
--=20
2.45.1.288.g0e0cd299f1-goog

