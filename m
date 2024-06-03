Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DE812EBF3
	for <kvmarm@lists.linux.dev>; Mon,  3 Jun 2024 13:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419936; cv=none; b=bVLxMRb1llZLNalbqGIM0utHSHrQofKXipkF1rEKA4ia/PYyaLy8AYH6PdKKgB/bkjHKM9pee6BLWGLD/3TRw6vmjce3y+PVsq954jguLpAY4zThrVJexQa+QaOzC/RS9PYMezL5kOqXmXdvp5UYcQODM3LErTNZDKSD0lowPa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419936; c=relaxed/simple;
	bh=Xg3rnsN00i+ckdDX25UYE+Fpofh+iwRaHfKXTsHVsqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L5+mGiFRo//DQq6uQ+QW/aUXYjEenRZ3w4N4isUYdlA3adMIPi9veXu0JoxdHr6PHWxWVYBhXnA+Z1mU8YYoaIecmgw4uoeR5dGlyeJshHHcXl5ylsyvEwU1fKtaR0WMKHppj8Y6iyvCzSSKWnQ9b/dnSG50C0tC+DQuYWYLVBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=edx0wG3y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="edx0wG3y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717419934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IvEydmzzbvl2Ff0xpZlhwXwl7LHoKN1DgH3CccwPGZw=;
	b=edx0wG3yeRO/pn2NmsybqIB7q6j214XYWlnq6y+inmNceAmV2H6kaM22IzhPqFrNIru5o8
	FoKXDTgJIAgVJfJ93C4cA50ry36WP6Y0GBeb5OEYzk9XTL6aBzZehTIacl+Q1CtQ+OfJ7u
	EgSuycgvmh7yzIHBe7SYhYokYNitrA0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-PK4sNpkHPmuKYxMjnYb2VA-1; Mon, 03 Jun 2024 09:05:32 -0400
X-MC-Unique: PK4sNpkHPmuKYxMjnYb2VA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6ab80cb23beso29794446d6.2
        for <kvmarm@lists.linux.dev>; Mon, 03 Jun 2024 06:05:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717419932; x=1718024732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IvEydmzzbvl2Ff0xpZlhwXwl7LHoKN1DgH3CccwPGZw=;
        b=IlblvtDxq31F56jXtSoDv7Y9NWSdAgbSDVympUmAuU8Vt+Qkh/6kkPNXNUv4EP7Sz6
         S1nmCzvDwufCSUvR+j+UB63jy1JdAKpIDE/CuPuC5ScH/HZIjoMZ7N1m8w2D9OpVYC2f
         Yt6XiKljB7CYdqANvdYKxy9yvgnAwfIUTXQ/btQ8kuF0aVpZUUpHx9FKg4WBJa3CwPnQ
         26A4HvvScROAOWYEWlzSuoRi16wddVowrffvU0QTwYDiYsq6nVa8XLp+IBzSe90OMRKc
         3x9yB759me3+RfawHhDyXMyNaJumOLHbQY3sGacn4YnwoDdScj4GDJ4dR9aK3O+g9vWl
         lzcA==
X-Forwarded-Encrypted: i=1; AJvYcCUpKqij46oAOk2k91RMUXjMDXkwpi9aWIVIJMv64h2NYlbSYD9YCz9iNaSYz8NvzEWpyEm6f99ojMP1exAyu2n+5cMu0iyI
X-Gm-Message-State: AOJu0Yzosw3kciOgxYTpYO9WHtsyr5NzcSTWqQXg5Y9Wpf72CkL5Ou8D
	7SQlcZr92X+gdgDYRMv4zPJjLgamNhqLG8Mci+ffc+22dn618BxZe46vqe5voJ7cLn/rlqg7Izr
	/Bt9G61EzCttJQvMZqja+5drFZp4vP3wkiI+Vsur7OpGwa6o1hJKr3w==
X-Received: by 2002:a05:6214:3f8d:b0:6ae:1063:eea7 with SMTP id 6a1803df08f44-6aecd598cafmr108985716d6.20.1717419931953;
        Mon, 03 Jun 2024 06:05:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG7+iy/Dv8ZzX13aFueLNEWj86HkkwR7fT77Dxvoy35+yUzuJEcF3YgXQkFlAET0CFWorT4Fg==
X-Received: by 2002:a05:6214:3f8d:b0:6ae:1063:eea7 with SMTP id 6a1803df08f44-6aecd598cafmr108985266d6.20.1717419931395;
        Mon, 03 Jun 2024 06:05:31 -0700 (PDT)
Received: from rh.redhat.com (p200300c93f02d1004c157eb0f018dd01.dip0.t-ipconnect.de. [2003:c9:3f02:d100:4c15:7eb0:f018:dd01])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6ae4b4179f4sm30558826d6.113.2024.06.03.06.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 06:05:30 -0700 (PDT)
From: Sebastian Ott <sebott@redhat.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shaoqin Huang <shahuang@redhat.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v4 6/6] KVM: selftests: arm64: Test writes to CTR_EL0
Date: Mon,  3 Jun 2024 15:05:07 +0200
Message-ID: <20240603130507.17597-7-sebott@redhat.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240603130507.17597-1-sebott@redhat.com>
References: <20240603130507.17597-1-sebott@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="US-ASCII"; x-default=true

Test that CTR_EL0 is modifiable from userspace, that changes are
visible to guests, and that they are preserved across a vCPU reset.

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 .../testing/selftests/kvm/aarch64/set_id_regs.c  | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
index a7de39fa2a0a..9583c04f1228 100644
--- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
@@ -219,6 +219,7 @@ static void guest_code(void)
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR1_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64MMFR2_EL1);
 	GUEST_REG_SYNC(SYS_ID_AA64ZFR0_EL1);
+	GUEST_REG_SYNC(SYS_CTR_EL0);
 
 	GUEST_DONE();
 }
@@ -490,11 +491,25 @@ static void test_clidr(struct kvm_vcpu *vcpu)
 	test_reg_vals[encoding_to_range_idx(SYS_CLIDR_EL1)] = clidr;
 }
 
+static void test_ctr(struct kvm_vcpu *vcpu)
+{
+	u64 ctr;
+
+	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0), &ctr);
+	ctr &= ~CTR_EL0_DIC_MASK;
+	if (ctr & CTR_EL0_IminLine_MASK)
+		ctr--;
+
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_CTR_EL0), ctr);
+	test_reg_vals[encoding_to_range_idx(SYS_CTR_EL0)] = ctr;
+}
+
 static void test_vcpu_ftr_id_regs(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	test_clidr(vcpu);
+	test_ctr(vcpu);
 
 	vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MPIDR_EL1), &val);
 	val++;
@@ -525,6 +540,7 @@ static void test_reset_preserves_id_regs(struct kvm_vcpu *vcpu)
 		test_assert_id_reg_unchanged(vcpu, test_regs[i].reg);
 
 	test_assert_id_reg_unchanged(vcpu, SYS_CLIDR_EL1);
+	test_assert_id_reg_unchanged(vcpu, SYS_CTR_EL0);
 
 	ksft_test_result_pass("%s\n", __func__);
 }
-- 
2.42.0

