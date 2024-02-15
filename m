Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F324B145B18
	for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 23:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708041255; cv=none; b=LncrezrDMEasqnqU6f/JJvqWI2IoRC/FNf7okzHoR66n9ilcIIxBdvKUO3LiMp22DMIXNYPIjUIJK6ooqZzPqODQg51Eos2qLDW9uEhntBAVkzdahjdgX8A7cqoU0/1PoxhZMiOHJPmrIYuYyWsXw8cYPhg59Sa9jM8NGHXTuSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708041255; c=relaxed/simple;
	bh=hE7An6neuPVvOGcFnrnVMg3xQPxzurJcj0TyW5C9ZWo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t7q9ZaPcYCY2nA3HE7WjtWOTpavt46H6A2eucC//NVFOr845rQomvHoaFqmvCmyxoBEyfwLjPeb7QrBIUvUzZLzdmVqwzGkmrQuuHLrIA0/YdxoqrRx0BWUuwVwvVqlKz+gRO7+mGdf+90nY5oYSR/hhHu2Lou1nZiRvf0dxKNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cuTpRn1c; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--amoorthy.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cuTpRn1c"
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dc6b269686aso2204171276.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Feb 2024 15:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1708041253; x=1708646053; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yo/o9LY2I9nX5aBe59uiruEUtYqrrYJs95LrQhRBOZE=;
        b=cuTpRn1cs+V6tXUY2cCt0CXzUmD8UM1HbzF2+AMBvShq97FMpJtYzqWxHzB73cBvx2
         BYSwWKKZzr0/4lmQ/6VqwGTvxV82pvf5/+PueHT6Q042kHzG7VRHAevXPbIz3XNILg2/
         srk7w+hAsAXAGE44kdNGEjX7x0kaZ3ezT9diSI3P9HErrfOWd0W398TdnSffGgbVNZpR
         zEgWKwN4HN8pygnTk7b4UbkdBxgpEez9AvolouOed66b5lbhLLcRKS4aYmgBPrPv6a2/
         3a5S4bcaq8qBt5JSN35yEZTOM1THodIrQxoqWMkm+X/N1ETvTVYFnWVJPTV98qjGV+HN
         CeJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708041253; x=1708646053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yo/o9LY2I9nX5aBe59uiruEUtYqrrYJs95LrQhRBOZE=;
        b=f+nyths/uc35JlNcqc1EcXz0ek8S7P/aFdB3comZmR8iahRhABhEHyOX85ZlEw6KB1
         heFqSOHtnHT7u1zk7C2G13OkF/kiruv7Ac+aqx1Ln9oWcqotmhIphy0I7UcTwrnHa0Ft
         iV9HtBzPqpVRMF9Qhc/yHA4zPxf/rYuSDsaMeBgmqvC26IGziIGs861mGLocmymHlqZg
         jo6DLZ51FpthUv/S6S7pVaflUE5GHVTFAtma4wKRta0jqfz7uLZPlBS0lD9Cn+j/E61g
         8EO8XMssCxfOyqVFHRRJZ9HrgQhKVrMT85eXPuVX+tqOARNTe2t3R44Fbra9Op+vPJGj
         wbvA==
X-Forwarded-Encrypted: i=1; AJvYcCVVUFIpCb8+ft0zDUAZUY3Cm0tSIwHmBjYC5U4+7VzbPFc4ZZFPrkDTYVasX3vU0MU3cP/rbROcPcvuHiVdo3Qh+zqqBEnf
X-Gm-Message-State: AOJu0YzKQeRWaY+a4UrecwN+te24osBMKZqFxmzNiJ3Udo5O8RrarKDV
	UWwXPkf2rhfN9AbStSGyY+8ODXGEnaicfo+N9UgbaEEHEy1SFse9IZNBx4NUArluzq6q2bWx4Qj
	NEWnkishzDw==
X-Google-Smtp-Source: AGHT+IEKdbXqNVReTvl5F0UombK5sQ0Ti7UMHJ2sVJ221GtcNLTwHyT9qTykKRnqFVP6BOtF0+Av1SRu6Gg7sw==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:1001:b0:dcc:79ab:e522 with SMTP
 id w1-20020a056902100100b00dcc79abe522mr129806ybt.11.1708041253060; Thu, 15
 Feb 2024 15:54:13 -0800 (PST)
Date: Thu, 15 Feb 2024 23:53:53 +0000
In-Reply-To: <20240215235405.368539-1-amoorthy@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240215235405.368539-1-amoorthy@google.com>
X-Mailer: git-send-email 2.44.0.rc0.258.g7320e95886-goog
Message-ID: <20240215235405.368539-3-amoorthy@google.com>
Subject: [PATCH v7 02/14] KVM: Add function comments for __kvm_read/write_guest_page()
From: Anish Moorthy <amoorthy@google.com>
To: seanjc@google.com, oliver.upton@linux.dev, maz@kernel.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: robert.hoo.linux@gmail.com, jthoughton@google.com, amoorthy@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"

The (gfn, data, offset, len) order of parameters is a little strange
since "offset" applies to "gfn" rather than to "data". Add function
comments to make things perfectly clear.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 46e7b8dbb3d8..7186d301d617 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3304,6 +3304,7 @@ static int next_segment(unsigned long len, int offset)
 		return len;
 }
 
+/* Copy @len bytes from guest memory at '(@gfn * PAGE_SIZE) + @offset' to @data */
 static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
 				 void *data, int offset, int len)
 {
@@ -3405,6 +3406,7 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
 
+/* Copy @len bytes from @data into guest memory at '(@gfn * PAGE_SIZE) + @offset' */
 static int __kvm_write_guest_page(struct kvm *kvm,
 				  struct kvm_memory_slot *memslot, gfn_t gfn,
 			          const void *data, int offset, int len)
-- 
2.44.0.rc0.258.g7320e95886-goog

