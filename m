Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D6815E5D3
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654967; cv=none; b=dljPkFW4asacvodwB+BmEzo9OIGKH4octnoJI1Tjpon2EGGaWnKqWjsbN2gxPcL5E044ubLuMyWoq1pls8x5ctwmaEd58TY4STreSPUT/hyNpttxFh++SOmVUwnm44KVz08vhEYLwgMjPd+RJhKH57boG7eW/5GiS9UlpljedYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654967; c=relaxed/simple;
	bh=oWnYdn0BgDHSxRNKslgfesdd9yEejwT/yhYAWEJx0EU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QMU9ikdaQM4MX0qzvW1byvK5S4alYw+YWo4lA71tLlmbLo51+o/3olOmjmq/r+9Tcm7GTj75oJr+4Hugo+bAnWmI/Oic9hpW4zmu24utKeBK+cnqv/j5pS3CLRh+uyPiV/e6WEwXj6YNVqelIaD39enluLhbPE4/XI35bIuHro8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W4DAoup7; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W4DAoup7"
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-62d054b1ceeso4632777b3.2
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654964; x=1721259764; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W1e4HHE4z+5Knov3l2/RvFGqy44M6oXcmkh1U5rufQM=;
        b=W4DAoup7Qa6nvfsNcPhsJMXlnaQqI+pA3f/nhCKUfBhByHJFbhuhHGTsKCIro9LgX2
         NwyIjVSm69EhYXC9VZjRlygNfeeRCI+zcNuk9A4xsrmmJpHrrBDMu29JWyIPMWQLQh8D
         QF5r53QV5ZMYtRclDbk+LhCLOT/l9LlVPp5Fwl6IbsXsQDw3HQJmZ3tWOLRy0WWkHNMu
         izt4LJe1Nsq2fYqUeIFM/YYYyix5mxNPQE5UnbrbmmnWGETryCdA0F0AtqdkfnJx1Mwl
         JdCaC/ucYEJadVIvWok40mx8m0EkFkFafAgknmpVgOVWdLZzrHIi8iaMx2nU1cgA+66/
         nx3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654964; x=1721259764;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W1e4HHE4z+5Knov3l2/RvFGqy44M6oXcmkh1U5rufQM=;
        b=bz0ahCRhy1sEwWxhHOJ/o0leh5u/p0cDKuYyA0p7UmJzwfhz6Nbouj3Yj1Mt4dybQM
         nUWjgBbUqVBQkSyAEpp9O1rAjjM8VIyA65x1vhW9FmISgrRDiQQl64cNFEQNE1lgZelT
         od11Jkjor8BZUN1MUVZoaWBC5QZUahhb6JUvsWCs9vcdy7YBR16VxIOTS1m3zL2YVd8E
         OsLnEI+rEH1mHiTKR2V6cuOyfZ8Hbl/PdFES0FC/9rgsko1N5IV4e0gnJez1dJN4FK28
         a0+GKnGPdKyl3m0u2zFYe81Uz14Ut+TfajMC+g6QLk24HL4cmG90hv4LhNd/qALqV7E+
         d3jg==
X-Forwarded-Encrypted: i=1; AJvYcCVh/92tlgTDD+I5g8IqUTqMORQ2tyqvLCTI5T3rosNbyZS5XjMt6nCh0Zx49kwsZRtLzaj1wTHI2aogaWUBRes4TbrnUmWR
X-Gm-Message-State: AOJu0Yx9qFiCBmtagLmaQ7CLz8PCTIQmXxtfSZ+nn0Qi6QhCsBiHdnKO
	aAEHJrQLKtQ1BxYZLqPybAS377KyypG84tyAF+P8wbYa2AW70OB/tUbZutw5Vo6YvcEe81LX2D0
	e90eBS34eFLfncyIK6g==
X-Google-Smtp-Source: AGHT+IH5NTISR7DBZbSKRJUHRXFWyLuVrVBePrqFfNwytKF1BLIU+MNslDD3lgHeZpjWWwkTnE/TGMGwZ5jaEHpH
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:690c:7244:b0:62f:22cd:7082 with
 SMTP id 00721157ae682-658f01f530bmr1591717b3.5.1720654963909; Wed, 10 Jul
 2024 16:42:43 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:10 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-7-jthoughton@google.com>
Subject: [RFC PATCH 06/18] KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
From: James Houghton <jthoughton@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
	Peter Xu <peterx@redhat.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	David Matlack <dmatlack@google.com>, James Houghton <jthoughton@google.com>, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

This is needed to support returning to userspace when a vCPU attempts to
access a userfault gfn.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 include/uapi/linux/kvm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c84c24a9678e..6aa99b4587c6 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -429,6 +429,7 @@ struct kvm_run {
 		/* KVM_EXIT_MEMORY_FAULT */
 		struct {
 #define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+#define KVM_MEMORY_EXIT_FLAG_USERFAULT	(1ULL << 4)
 			__u64 flags;
 			__u64 gpa;
 			__u64 size;
-- 
2.45.2.993.g49e7a77208-goog

