Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5325371CE4
	for <kvmarm@lists.linux.dev>; Sat, 29 Aug 2026 05:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787982630; cv=none; b=nnXpLD6urorhNrmE6vjDSbK6v7VFCVHEcymUeZjMTeEzMo9qNt8zBmUMpb53A3JQqFcb7AYg7ygOyq3jVbknrrQSOdM3LIaabcReWiYx3ik0VA7bLuunY6Y2v3Z9IhAjtOnrzHeZEG/Qpw8Y/+8JjBK6g+zfYXQCThTs2SIZJE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787982630; c=relaxed/simple;
	bh=Q4xDvcP9DIiwYXTXpczLlLyq7Kd7CsRktQVDTGiaDVA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QAeoKKOpjIPBLS6eCBsXH3UWLodcLnvQsQ+WdExQH+soGzs4wPnGVSMbZpbtK7uDr18m0SgQZPuPBYpBNwTrCsUIH0R6nSml3feYGikrQLKowOCcboGs3gRNk5Sh9LIC00KZ5+fT5/WYBB18Vk7UF7HYA5+ab3SgBW1Tqwwgalo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WeClMRNZ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeClMRNZ"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49b392ccaacso20660945e9.2
        for <kvmarm@lists.linux.dev>; Fri, 28 Aug 2026 22:50:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787982625; x=1788587425; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gmU2GuULI4+ubbU7oraX4k5FiAqeW6B2DekgWiWauec=;
        b=WeClMRNZU9TZI+vff8/+TnM0MM4uGDqhy7Ccs775ZLmIq7PiopkvkAOPhaiaRi+xd4
         VH6Xb7POLzu/0DewAKKr3bybVUvyXJGt/hf3WEThPCPSh2qtrrg8ZJVyAgO0dVtOlpeg
         xFzqWU8ex+1ilfx0ZxHsL91wor4lKxKHMRFdSx1ZX8LIyqZtUmfEaqOB8wsgWWFofqOq
         g+8J6dio0DYuIyXYU10RibUOuXMN3Uh8FgEIZWj82n8IO+O1umEFWZ/J+HCYujoBYsm2
         TlKJ836grB3wLzpioo0iUIYfASCDZ7a3CsnyA5XWFPpp3e9NPkP9RYseJtoR6I/yqWBW
         LLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787982625; x=1788587425;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gmU2GuULI4+ubbU7oraX4k5FiAqeW6B2DekgWiWauec=;
        b=nJWjjiXDtWjCNe6RrUOSO2Z8QFEQ4eexr+hua5onqiDE/QZsssljvKsYBp5BFWu/Aw
         jrc3uGDZ7W0+TOiVsl8z+L9dlzZCLyOwSWzm96zj7ATSPO41uhTF371k0JrSqBEF/EG4
         Eivxg9QhzITLawVm4FYKMTOTPTDFSm96i0dmrKDGOnJHHMMDm/vTmMWoB3ry0CjW/l2J
         XsHD/s1D14i/O7eAanjJmUQJxFMSv9QisCvVyhFGIgbWROKAzTT2wuBf5npNDkQa+Bei
         pMZwE8M2Cs+DX/aq+oDJr0oiG9JdPWkYa0HJZCUjcljIada3K2c49SO+204Mw0xz4iNM
         l1Uw==
X-Forwarded-Encrypted: i=1; AHgh+Rq7VvR+rViamjRPV7PTyP9NHcsDC1FBd8Ri+l+3JKLjM1BfZDO8u1VfC5CFXkJ6QS/OMFDHToU=@lists.linux.dev
X-Gm-Message-State: AFuF++kjaiQmwJAg/7ImFRV3yNj9TZkusky+4GIfqPJGGMwM8syGCqKy
	nBNyf4cQMXmrdOVBSRI5lUHuUoQ3E/sXMpSAZYUK5zMGVu9RM9j/OO2P
X-Gm-Gg: AR+sD11gY9DYplgh6a9naqOV/d9p4/klkq/K8XpfzqYM8leB/GvjHIp9LJIMlO6VvLg
	3ilkmn3iaLI0mC6yacxYrtj4zhztFJaliwIO5jqgTBTtR0U/KdbFwrrP36MoHf6gT1s5183OIGQ
	abwcwGOVXYgc/RrzWppMmLo5FxYiWW3hqANrzchFwYo4ORU2D7yiTbLQGylGqN9fm5O8a9t7Zqn
	2pfUOFb5WdPiw/Dy1RJShDMf+ffdzuVdCUZ3txfvNS243x87cPSvI488iKBNoaI0JkpNmdnQJCz
	0CcoPN51NPgujqWt6kP4dUBBhsJ77pxibO1rSj+OjEYqWg98zZwGB3h6EQQKlYgNmr/vP+Xnts5
	069Fdzy62ORBBf7zW+YaQjr9AwWMY4AN5mDDjkAuUWcVExyj//D69Qy/EbVxRi/8xOtUhx1rpud
	DMMzGinkTpnibDFwBRDpKIK1pR2aO0FA2nlPmfH30ONiy08UeNIDj7Pdu4bv2ORsM06MD0E5gNb
	Zl/k2bvA8P1PoUhpUCxiRIBdaexBnvyxOXCvLhfNF916H6Hp2FPRxdwlUmpSgpEUGkXiFWfSfdf
	hd3wsCdOh5kL6T1XOmzg
X-Received: by 2002:a05:600c:1f8d:b0:499:621a:2ec2 with SMTP id 5b1f17b1804b1-49b91c17c41mr163125035e9.3.1787982624717;
        Fri, 28 Aug 2026 22:50:24 -0700 (PDT)
Received: from localhost.localdomain (dynamic-077-007-015-136.77.7.pool.telefonica.de. [77.7.15.136])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cca3e642dsm35357485e9.2.2026.08.28.22.50.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 28 Aug 2026 22:50:23 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: selftests: Test empty SMCCC filter range at base 0
Date: Sat, 29 Aug 2026 07:48:56 +0200
Message-Id: <20260829054856.70549-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260829054856.70549-1-kmehltretter@gmail.com>
References: <20260829054856.70549-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

test_invalid_nr_functions() only checks an empty range at
PSCI_0_2_FN64_CPU_ON, which KVM's end < start check happens to catch.
It never exercised base 0, where the inclusive end wraps to U32_MAX
instead.

Add the base 0 case. Without the preceding fix it fails with EEXIST.

Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 tools/testing/selftests/kvm/arm64/smccc_filter.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/smccc_filter.c b/tools/testing/selftests/kvm/arm64/smccc_filter.c
index 21e41880261b..a41ed3e016ba 100644
--- a/tools/testing/selftests/kvm/arm64/smccc_filter.c
+++ b/tools/testing/selftests/kvm/arm64/smccc_filter.c
@@ -140,6 +140,10 @@ static void test_invalid_nr_functions(void)
 	TEST_ASSERT(r < 0 && errno == EINVAL,
 		    "Attempt to filter 0 functions should return EINVAL");
 
+	r = __set_smccc_filter(vm, 0, 0, KVM_SMCCC_FILTER_DENY);
+	TEST_ASSERT(r < 0 && errno == EINVAL,
+		    "Attempt to filter 0 functions at base 0 should return EINVAL");
+
 	kvm_vm_free(vm);
 }
 
-- 
2.39.5 (Apple Git-154)

