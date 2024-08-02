Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671E413A895
	for <kvmarm@lists.linux.dev>; Fri,  2 Aug 2024 22:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722638466; cv=none; b=R3xATbLYKvNsk9xbxTVxbrTQaITex4sFx9y7x7F+zT3s5TFC8SPoudvb6KMdojuDuF2/01m988IgDsG5Sqiv2nEhLyg9pL0XYSIDO1DLVm88Z+kjnT1mbqZpx6Nhlsbsta5XP8UYnhlC6/qXokRpiDt7UxW0JItBvSWO8PWBcnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722638466; c=relaxed/simple;
	bh=v3acPLwhV+gpk7Lv0W7XpGHBnCDV1cxxTMNqqwFABeo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HMhVWRLfOEwFvqw4Qvi0z9nvTvQGwVoAN7rVDUhOD/jCQJLrL8j4JaLG9rc7jVTbi0JSYayJsyjvxROcs3eSzczM0Dak1UbN9AGJBGMlmrRQJ7IGM6sF0OncNQl/BC/P1zE0YGmLSGEY7eVHox/Ga8XUF4BFFlMWxKaqUKH8Il8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yoyGBGtF; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yoyGBGtF"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-66a2aee82a0so175886347b3.0
        for <kvmarm@lists.linux.dev>; Fri, 02 Aug 2024 15:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722638463; x=1723243263; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WUTD+PpdYxApWk0wW3A8Rkz7siPlFF3F1FyTT2F4Hns=;
        b=yoyGBGtFKJev8SVLMyQHQDVJGpsgkL9nbrVpbCTMqBxMeXJWDcbjsOrdIiv3P/Gtpu
         beOigiyZKnrM6WiqFDXUp1h9Jz+VO44kosj9MGKOw5KIdNQJjzrGwlZraZE3UG5klqUt
         a/xtyHUD5UQcLaPF+YRA7xsX9T9GV7urkYRVfH63nryi7aVI7mu4mg0K2vAB0uPyvODZ
         PJnRd12zqMhqttLiqaLozwdj4tJlA035mLaO6/k5Z3u9XmiKXdqrpkdqrQYAg1luyyM4
         h8oXXytaA22ICG1RYB8S/aJ6MVeZZmnLtyEeU+9dgwBU67tonWZyRL0E2dVTSqhVAqkt
         RJ6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722638463; x=1723243263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WUTD+PpdYxApWk0wW3A8Rkz7siPlFF3F1FyTT2F4Hns=;
        b=b1bhNNyhDHRwyUude8rKVkr8otzXX1q+kUJanWqssEzu5q9iK6sXXMx2WHGAdHVoFO
         vkvdeB+U0zZ27DH1LJoAgpH7loIwXJ0dsW1PRqEUVKLV6wPvK3u+vl10XDZSNNqlnxsn
         xYv9Sb2t4FlKNq5Oa2rJ/vOykCZuBPNFG0SdMf0GkgELoXDpM21FK6FaFDydjnhdzIsh
         4CQy2hviAYAMZbfnPK8r40QitbQ0Hg4ZFOOipgnmfj2GrserjKVDqZOufCjt3RTeW5q8
         aEktv8BcX8cJc2qJ+siTI/sTXIIxrje0ytKWd1FhqWLZYK6kVav/KhO6W83sN4XoIiFt
         6+iA==
X-Forwarded-Encrypted: i=1; AJvYcCUu0JK/2FnxtuGufO/Rxk48O4C0DLwzj/nkR7s7k0ksbDsmPkaeNtZiR7V0VQ+vO1rn4xe6waCyvtWCU1CQXqlZijMFR0A7
X-Gm-Message-State: AOJu0Yx/TKoaKZJwVdE5QnBmHmT9zomJQAirybRLfk+XB8QE5FXxbOWB
	8Foip0evy+a5napF6r1HZbkGsWi6/xrERAch7XUdEO3wiUSJDfC9ZLkLaIBmpxUyHS/Ww8D1oh6
	h2gXZ4S+2/g==
X-Google-Smtp-Source: AGHT+IFKNhjc3bbOHyYY5UfiMGDF2uVqzD6G4qc/2EsStmrwR8+ngkVWR6nBrvU9pNgNKVw3FEM43mqMAO/ycg==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:690c:dd1:b0:665:a4a4:57c1 with SMTP
 id 00721157ae682-6895f02c633mr602787b3.2.1722638462564; Fri, 02 Aug 2024
 15:41:02 -0700 (PDT)
Date: Fri,  2 Aug 2024 22:40:30 +0000
In-Reply-To: <20240802224031.154064-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240802224031.154064-1-amoorthy@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240802224031.154064-3-amoorthy@google.com>
Subject: [PATCH 2/3] KVM: arm64: Declare support for KVM_CAP_MEMORY_FAULT_INFO
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, jthoughton@google.com, 
	amoorthy@google.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"

Although arm64 doesn't currently use memory fault exits anywhere,
it's still valid to advertise the capability: and a subsequent commit
will add KVM_EXIT_MEMORY_FAULTs to the stage-2 fault handler

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/arm64/kvm/arm.c           | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 8e5dad80b337..49c504b12688 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8128,7 +8128,7 @@ unavailable to host or other VMs.
 7.34 KVM_CAP_MEMORY_FAULT_INFO
 ------------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that KVM_RUN will fill
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a7ca776b51ec..4121b5a43b9c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -335,6 +335,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_COUNTER_OFFSET:
+	case KVM_CAP_MEMORY_FAULT_INFO:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
-- 
2.46.0.rc2.264.g509ed76dc8-goog

