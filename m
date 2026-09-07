Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E338D3644A0
	for <kvmarm@lists.linux.dev>; Mon,  7 Sep 2026 04:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788756302; cv=none; b=XIRrVOpDAz2EDA5acm6lUWOYJ93UEtBNU2rn/5EV0irCrx4pBpOZ5Oo7Te7fkdNqxrPXB+jp8NYrczmxnWvB/Ld7IU2lrdbwXAJVQA0KYjVkNeKSuuiZ80L/0dduQ7YAh/BjkRKLVL3xSZAwrsuzFxnIVsqHsrUmUEU8I+/Df2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788756302; c=relaxed/simple;
	bh=GXik8XMFxKlyNr0DJa0gcBwazjCkzO5/wY0cetFN0QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ViQImQqwNrWUpTEGSWa4ShRhZSwpWARFJfIpCz0sTl1jYVocEGDxTP9U1wAljr2MP7Uz6APthcI8v+SWP/dYpdnNfE7VuGP3ex3DjD6752B8TfTmBJRh8AB8RDotLh7DXQDHx/QV5tn53WgYLK0Fitdj92t6RTertdxITt5TCVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=feSQzV7s; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="feSQzV7s"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso3927105a91.1
        for <kvmarm@lists.linux.dev>; Sun, 06 Sep 2026 21:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788756300; x=1789361100; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DnvU2vBpS7iNRhfGmKqIjpkiFHsnHeHr6qR8QCexTas=;
        b=feSQzV7sAKZ+A7cqqtpKpNc5a2aDe70XNMy0SBAV2nffPXUsXaLSXVunTk9NfivII+
         Rqf69nrQVnw0HRykF/q5PhAPSeIgc9zm+PhMlxdoYwxUvxtQK/+tdSHKUuMywLDqgdhF
         MhMTruNDe95MOa1b83Z+fyPkxzCdI331WTPYf66ZlsYp58j0TuSXwU+0e4h9ijqAllvZ
         CAWz6mvBhuP/k1ZKi0vqrsEhXz6Tx7YsEwXBGF7/v2mkfcRUJT2lZjvL4Jdq0uL88QUz
         BFMLAnpHDc99Ov3H1OTvUlViH3/VvPTjeK0p3iyb2pZzbM0haFZ35L1ul93qZZe9j2iD
         f7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788756300; x=1789361100;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=DnvU2vBpS7iNRhfGmKqIjpkiFHsnHeHr6qR8QCexTas=;
        b=jawULFfJI+QAOQyBWHMe1+RO/1zFyb6/BFvxCIqLsDTTZJV6l5fYpu4EveVOrViFyJ
         Y/lEZDyO1k1+y6gFz33tZn8u8vLoCvW7/EQJy6vtm9y4inv2fAonf5dPDntPe+kCjTaw
         tACNYks1Sp5DQrSRwZtAtuRb/zxJwuhPcEoFQ2k8eSVW6qJjPRk8ziQFKh3TLkajV5UW
         9oHXl4U9/My6v+VmJtDV6qIqCFF4ySvIVXOvVCTEPS/cUuuJuqZywUMk5MKkZ463lENo
         VY5USydXB9sqsVu2rXwkfYn/w9kyypyYoS6EgWQhoUloHo6//Vp7uTmXOneHfRVEv9qS
         QTLw==
X-Forwarded-Encrypted: i=1; AKwUvByz0rA6ZWPrJUhSPpk01isl8cRbWHB6B3+us2Elx9FP5u4UTZai3UMcZYQvp7lilWJDxNGdxEM=@lists.linux.dev
X-Gm-Message-State: AFuF++k0mSFqf9cRlr8qz4BkT/2mIHYRLvb/BGIW1unPE/CbmIPs6LO8
	fFkNx3ml6xUJpxl14gNBmuxdZ2XoOiEBnldseoh/LvZmyKDMr0wG0Ruq
X-Gm-Gg: AYBFou2KRBzu449Ev6LaSuyHGhTw7XJ9Dpvgz338E4gL623hQpMnES9MU3rGIgv1KTG
	dMq3LcKTQmOQrWx++Q0jsP89hGVVXUTqQx7Jci059O3zZtMXgaC47PPihp024BKWVLPbr0O7ATm
	iESVBBSKd7BK4BXcs1HXGkvif+JsooFVrdhyyPFoytiHShHh4VUo5nRpNWBWUvom29WoFia8ZsB
	8QUNiulAWIMoehHN+2hxV/9D+SR1YGbJrGQfpeRmJYi8bpdWjZ/h8qr1n2NjdT70bnIzITNVga0
	1ltJtzGA89BnEmx/YtzJSQd8LH7/uYjWNc4lCEeDvZtHVJUgajZ1nHgWcSO5Ou+sTu75V7NouGT
	NGDyEKM1rUT9emo2CjrjgoNpSif+OtI/K/eifWYhHvrxHKH7Dud6LAd6Q98awIpxA+nC7VBf1N2
	2aTfW7s23wBAymsOmpzwdmPVHfzSMdJihNOdShMI2oq6dscZQKvQEpTWote/OTSsuYSx3kqbUpV
	L46PLiBPJbEgA==
X-Received: by 2002:a17:90b:268f:b0:398:c3a3:dbd0 with SMTP id 98e67ed59e1d1-39b2612eb96mr32751634a91.8.1788756300129;
        Sun, 06 Sep 2026 21:45:00 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339af25062sm37823751eec.16.2026.09.06.21.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 21:44:59 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
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
	Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH v2 3/3] arm64: kvm: fix typo in pauth.c comment
Date: Mon,  7 Sep 2026 10:14:34 +0530
Message-ID: <20260907044434.4682-4-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907044434.4682-1-hemanth.selam@gmail.com>
References: <20260907044434.4682-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The comment reads "This code assumes that is is run from EL2".  The first
"is" is not a repetition, it should be "it".

v1 deleted the second "is" instead, which left the sentence without a
subject.  Fuad Tabba pointed out the correct reading.

Only touches a comment, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 arch/arm64/kvm/pauth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pauth.c b/arch/arm64/kvm/pauth.c
index d5eb3ae876be..bb6c42e78058 100644
--- a/arch/arm64/kvm/pauth.c
+++ b/arch/arm64/kvm/pauth.c
@@ -5,7 +5,7 @@
  *
  * Primitive PAuth emulation for ERETAA/ERETAB.
  *
- * This code assumes that is is run from EL2, and that it is part of
+ * This code assumes that it is run from EL2, and that it is part of
  * the emulation of ERETAx for a guest hypervisor. That's a lot of
  * baked-in assumptions and shortcuts.
  *
