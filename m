Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795735877;
	b=UwKKJS3SYgtJWk/i7cZk4uyEnmr/YiqGkV5QouYq0JbgIP6YRUSW+zpvSmgOrPjdbhTy
	 PJ72wgk1DDiqlJJpDp5lPgffrgIXOaJ/k93+C2SRymsVfv6DvijRg1u/cm5FrowlcSf16
	 5QTwZ7mr8QTpcSFpLk30F83T7dlOUXH1VuiigdardQJUGJyK+PEJxcjsSHb/mniMLL/PW
	 FYH6NPEU7lNZR8clFfzPMbMd4erU+DvQaYBCFZwzD93R+knlww974fi2i/SKAlPxwDTsX
	 Gy9vJvuIO/3dlg+ObLcqyLSPMV9sDQ6dLKuB1sLs7hn+I00slO3TIKCEdxXoi50ElAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795735877;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Bbz8LNU5azQdFUh5fnUImloX5/acT18ctarlFycpFR0=;
	b=vMEaGManLCtlR1NWSGv8wDbSzx98KjDo0bs+Ld0NujWBuGibeES07ff4yUNHZ9ZNxxOc
	 GNdZJOBnQJDqyUwtf2VpoaZRZyUPl1wF7VPldn0QGJFoI9u9eaRlmFo4yoHEiM6oGC1kb
	 Wxn61DvJ467NKrUT0VISwYMepl6lBa9quSsTUxsoVXn9PX9bwlPoz/dQ/6iSs69Y3Zo5h
	 9LlheP4qZ4BQNjZo/0SrDiXkza4SKjzmkHRsEKyqhTn7j9TUPESVlPlVi0mTdLLXvVUbI
	 +zZS9S99U24MGWdXyVNhYTO7vYfaCt/uqnghGO7MxOumuKUDecs8sp1REUuS6htGwAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tz8b2qe0;
	arc=none smtp.remote-ip=209.85.214.179
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4539606A31E
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 23:31:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4539606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tz8b2qe0
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2f02ee04378so58595535ad.1
        for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 15:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795735876; x=1796340676; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bbz8LNU5azQdFUh5fnUImloX5/acT18ctarlFycpFR0=;
        b=tz8b2qe00iSC8LjtKjgbG23y3sYJFLThrXo2SGlv6DBcUPITfLKYOL/VOXX16r01gn
         MJGCuRltcgYfCKrQujm7xTYXpdPOJv5oHfAQnIxy00gNx6d/TcdanzOkrtFltWjk3bVa
         kcfTh8Pzms0/sny8ntFwzjDLeevyv7qVwNReduu18cF+3vyiuokCDXJA6klZ1R5PJQ+T
         UTTbImrwZZk+NK5lDooPjEYzGxralByiRZcAW6tDBoQR3ql4EdJZCcepkEvU08qPlP47
         h0qbmaJWzLt0i2f1irXWr+ud6XdI5hazGBlRMWeLaAwNCVJk2qWlIMtb6Cmh6OWkjDNv
         ChKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795735876; x=1796340676;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bbz8LNU5azQdFUh5fnUImloX5/acT18ctarlFycpFR0=;
        b=HWHMfusE8hCD3hp+gcHJpZZBSX898SOAdk0QFxjMiqmyptGrIz0DajkY6dI6xeJBwM
         fB+lvLpcbVB0Ss3fmlAVnZ4fE9/e2dNPujsrY6Cei7Mrc60DZYzlKj1buSDLkJNC1aNo
         CCv2ejnp9DJU1+nLBCmBaPKmK0UQB1l0KLgtdVRurAL1QQW5+4nWcE0179pbDl0bo81p
         /dF1aH0JZ8LDtywm4DMtU511CGyxKHgLCUB2dVkSCxbySG1nq7resdZmzxlbHdGvE4og
         +5PQG874A+EPPgI2IHqGxYlsah30314ghmaQj5Pg7QPkXY58pT/5+v/3F3vDT8PND8FA
         Vo+Q==
X-Forwarded-Encrypted: i=1; AL+hErEMjseGCeUT3EH8XuG2iUVNhiktzjahou77CGk408pIraNrzZa8XVnOaMPpSjDoCQkWfSYWNGA=@lists.linux.dev
X-Gm-Message-State: APuU4Z/MAdXUKvOurAnQiPEQkhCEiCuKdlhvxD7Ay2/93ILWhCwx9YlG
	S3qFwbJtSZcq1dsW/SSMhrnuIwQQ6XMSs3zdTLEMRm9ha9SY11jDebWv
X-Gm-Gg: AZFdTZfskSfX1S7009vxYVkx79fV1aJEfLd/dVm6Wf/N4JYSKjY5WRJNMUxIewIROc4
	8EOsMFciu3HYEBTBKI07lCLDknb0qcksD0SyC8qzpzeXxDNlLNRKNK0YVxcWwCniTEhkAPTBboX
	GCz2sIkdEAKm1IUqDumJR5V4pF1cKCtJ+c/CwLOnU5lGEnGB/eFfGKDkHhmPdzMG8JkeckD0RTn
	4wc3RgrfqaHNtiUanIJSNSzaKyRLlp8e9WxgXejnezBGkSGDWbXDoxDp+ioIEvr/xZZnPoT6Kbm
	Z+A5RlbFDGkQjDrjhzzegDz7y7phI5i6sTihqX+KOzvKd7LvqXmeSPFrDppqGIw9msNSS4YE8I+
	sQO5ktf5Hybv28HzSfnWTgYMpDaI2FTXlKLzJviteyXgn8blw6ADRZ1xvajU0LAfUkAThRI7ktP
	HNFLe9AWohOFrewuPXIEhEes5prsi3ej0YzJEx7sT5ykegpFkYDJVqeWw8nf710HpstomN95PxE
	8wfMV2DiOnAk4ik1gUeHvWfCm5rO+5sv7e4s2CIg1aIgL989LVw/f1PIX6yaMjd8E5RSP1lcB86
	8YXG9k+0Iv8j7iyOsZjcMPZDsRW6YLCA6Co1mLv/ROdddPCF+A==
X-Received: by 2002:a17:902:db11:b0:2ef:eb06:387 with SMTP id d9443c01a7336-2f03f246dc5mr238581485ad.47.1795735876217;
        Thu, 26 Nov 2026 15:31:16 -0800 (PST)
Received: from fedora.tailc1fb0a.ts.net ([172.219.65.15])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c42b1sm108793055ad.17.2026.11.26.15.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 15:31:15 -0800 (PST)
From: Artem Novak <artem122novak@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Artem Novak <artem122novak@gmail.com>
Subject: [PATCH] KVM: arm64: remove trailing whitespace in reset path
Date: Thu, 26 Nov 2026 17:31:12 -0600
Message-ID: <20261126233112.71504-1-artem122novak@gmail.com>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace the tab line in kvm/reset.c with an empty
line to keep the source formatting clean.

Signed-off-by: Artem Novak <artem122novak@gmail.com>
---
 arch/arm64/kvm/reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 10eb7249aa9e..6116c9ad054c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -108,7 +108,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 		kfree(buf);
 		return ret;
 	}
-	
+
 	vcpu->arch.sve_state = buf;
 	vcpu_set_flag(vcpu, VCPU_SVE_FINALIZED);
 	return 0;
-- 
2.56.1

