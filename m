Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B144DC90
	for <kvmarm@lists.linux.dev>; Tue,  1 Aug 2023 15:20:15 +0000 (UTC)
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-268b931c2ceso2470806a91.3
        for <kvmarm@lists.linux.dev>; Tue, 01 Aug 2023 08:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690903215; x=1691508015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a5ITWAYN9R9rtf6GERIf9S362dBjLzTbE/fVZh0ZgOI=;
        b=fTiv3bmYN2oeWLkbMRJWsRtibsFGBoi0gQkakqnsftyey8XKIY3KI9TWKC8m7nSIjs
         NU3H7wmRc2rc7oOlaOdQL2IBo45YKH5vcbK0iGjj0t4gfvif1gUgKclwpH/iyXmxh1NC
         3xDB8SEk5B/REEVEbmivjGhpoLf7jrnXFq/6HiJ5bOtUsLoETZHjbgsRNPpMjw+B5Eqx
         Kk721CF0oK4/0A+jq8UCjBsKLFh2/nHmEeOqzZNrY+cZac9cU8hOVCWV/eZ7Z3XeSSHj
         Tfpkt3e+/dxWeOl1WibUD/ZMPoJo1dGQoeKBly6GsqqSic3dS7+AYCkOAScuEABTaNdU
         4mzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690903215; x=1691508015;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a5ITWAYN9R9rtf6GERIf9S362dBjLzTbE/fVZh0ZgOI=;
        b=ExQbOBybUZ1/zf92AAWBLw4Z/yL8HXdm8b+d8uqCYLFVgpfsZaH5mjJPlXNTcSoG5t
         TzURd/D4q2wwhH9DHqsYxKIPf8OX4C2ibQt6FvrqvjV7BRutt4sg/rfJlO2W0X/syDy8
         o+eBOOE43RPxmzY2XS7lTiEAzePjNsfhr3w1mCGSyPUKX78hq16xpSLdmvxYRkr0ZXuP
         GHxQrXHUW4i4SkXsUszT6zBFjE55yxUHcZeC4PuxBpfNxewyJOTM5zdheoSnJMlVwVeK
         bJNm0w/75nV+AddBlK9jit34/I4cV7yOqqyOgUQKGRIScqe1fLcBXMVwu+MDgNO9E7S1
         fEGg==
X-Gm-Message-State: ABy/qLZTHPKuW4C/9KoSWEtZrpCM0yMZ6GyEkK+BUanhAOHmt9tGajAX
	a3FYkIvNMrQkfbReLe2Ss2jOCQOGB0FX8Y7C0w==
X-Google-Smtp-Source: APBJJlEnPd5fAD0Aj5PY28l23CVy0dGlj5CAymKDeYm7SNgmyFCz9I6QMeDLMfXxJSbBI+IkBdoRqH8Wa5L+RyznOw==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:903:1cb:b0:1bb:cf58:532f with SMTP
 id e11-20020a17090301cb00b001bbcf58532fmr62253plh.0.1690903215344; Tue, 01
 Aug 2023 08:20:15 -0700 (PDT)
Date: Tue,  1 Aug 2023 08:19:58 -0700
In-Reply-To: <20230801152007.337272-1-jingzhangos@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230801152007.337272-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <20230801152007.337272-3-jingzhangos@google.com>
Subject: [PATCH v7 02/10] KVM: arm64: Document KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Raghavendra Rao Ananta <rananta@google.com>, 
	Suraj Jitindar Singh <surajjs@amazon.com>, Cornelia Huck <cohuck@redhat.com>, 
	Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

Add some basic documentation on how to get feature ID register writable
masks from userspace.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 Documentation/virt/kvm/api.rst | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c0ddd3035462..e6cda4169764 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6068,6 +6068,32 @@ writes to the CNTVCT_EL0 and CNTPCT_EL0 registers using the SET_ONE_REG
 interface. No error will be returned, but the resulting offset will not be
 applied.
 
+4.139 KVM_ARM_GET_FEATURE_ID_WRITABLE_MASKS
+-------------------------------------------
+
+:Capability: none
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct feature_id_writable_masks (out)
+:Returns: 0 on success, < 0 on error
+
+
+::
+
+        #define ARM64_FEATURE_ID_SPACE_SIZE	(3 * 8 * 8)
+
+        struct feature_id_writable_masks {
+                __u64 mask[ARM64_FEATURE_ID_SPACE_SIZE];
+        };
+
+This ioctl would copy the writable masks for feature ID registers to userspace.
+The Feature ID space is defined as the System register space in AArch64 with
+op0==3, op1=={0, 1, 3}, CRn==0, CRm=={0-7}, op2=={0-7}.
+To get the index in ``mask`` array for a specified feature ID register, use the
+macro ``ARM64_FEATURE_ID_SPACE_IDX(op0, op1, crn, crm, op2)``.
+This allows the userspace to know upfront whether it can actually tweak the
+contents of a feature ID register or not.
+
 5. The kvm_run structure
 ========================
 
-- 
2.41.0.585.gd2178a4bd4-goog

