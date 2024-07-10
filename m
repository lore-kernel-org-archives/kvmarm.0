Received: from mail-ua1-f74.google.com (mail-ua1-f74.google.com [209.85.222.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA2F15EFAF
	for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 23:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720654968; cv=none; b=V5rIT3MyqvMZxEdOKd6MiLIAlUag3u02JPNIRjrT3NE8TKZ5VWbPzeg5aPSCPBNaVKWW4A9URxW4Hzx9Coil1DKIwOAzCJSHOr5OqtD22eGZxPiOUMeDDPV/OYGJAZNrQIhidYIMCfI9cOcKrTlbA34nalLvxorbBTGLFjEdea0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720654968; c=relaxed/simple;
	bh=0X56a4gN8b7VQgThnVkXYUH34LPfOMnmnpB6+EHKoT8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lfkqlfWDV1BZtlaZkirxBZvOT+mHveicTgCUqvRdT+4na8UUujdSOtHmTap+hFSlE0E4r0LoXySwW83HDdLbNeEo0TqWcbObYzEy3aqoxzhm3/GUMUwqOj4FXHzAUpsgJvBP4ULQg3h6iLd4E5GzNsmknSyX4TN0g1KCctHyONg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VqeDk7Ri; arc=none smtp.client-ip=209.85.222.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VqeDk7Ri"
Received: by mail-ua1-f74.google.com with SMTP id a1e0cc1a2514c-8101a565f21so75340241.3
        for <kvmarm@lists.linux.dev>; Wed, 10 Jul 2024 16:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720654965; x=1721259765; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TURU+uj4JjtASnposo8ch9F78eTbKidxkEMdeXOCkww=;
        b=VqeDk7RiKtJ0qslu1uwPlv4tJ2lro4+1U6xvjNX0Ahm9h7xEJkBbrSXgIxzzqzzzgq
         m3LVnMQDZE1bjWThdRdWh3IYO4LQcDuwlMROvWzrWZXGgrgz+vqx9GZigctJeTRUVf1g
         8uNIc0ypRPGkFH/ztYksujVz6yiUxQM4QimrEZ3bsMw0cefdelcwEkTWndRhawQapPxW
         tHO20oCj33p4cTAqOF1WO+HM6mRBFxFl5pZ6AvbFGtjpqbdIQ3IpMg66TeoHMfrD6DSe
         TIVishODN4aYiItLuirgUOgLlYojsipHCqSccR45YwxFLL87fczoJ87RbmJUVH6jOTje
         22Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720654965; x=1721259765;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TURU+uj4JjtASnposo8ch9F78eTbKidxkEMdeXOCkww=;
        b=kaiAbd9gYrtIHwer2TslJbe3FUc1CRdlrf82LuevwxfbYp5Bu+0CNGDuJ8rYkVX33H
         xXEqgaiaRsDJojGw/yaIdmRBmZvRY1a2tfF2CTAM/f6CVvlpRS4Z4fmGSgkikTgXJCqi
         K9OuqmS+k6lo69iQ0AJTm5Mtzzsej8j8iMGKRQGyblmKx7ISZYNXXwOfHePak6ZMFaBB
         5E6xiUVBkhyaZKz8XBad3SmrhoZQH/9y0byn7oyBktd1ItBpoTOsol+0L0Iup2ugQkO4
         bOWnDc43D6m/XXpMOfknu1evb+fL/t9nqxjZSYO3QxPKbJsFUqMsIlljQ3KH/BAc3LxK
         IyaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXyFTNQQi1mMlak8xpU4Ud/1q7i9HEFxyfbJBaL120zH7qx4Akvu5pWDA2c+PoriMjXMS5SWZvTAN2aDs9kGoDblFjLJfuk
X-Gm-Message-State: AOJu0YzoeM33tSQeB2+DtHUEgLwKnBb8Do0J8leZeflDT9MVRglL54Er
	rqeMiRAnPmhWkh7tHGQ3lXmEw2PJxEx/0ojXqdv9BT/nuB6HIlzBQHeKoLJ0Coo8XjUVdjFJ3q3
	4NTHL/FJkA3JdVkM46g==
X-Google-Smtp-Source: AGHT+IHwjQCn8pz3/iqiomOrjrLQUXcW8j3Cmfdd9IBi0Npw4AjyC0JLSC59kn9LukO94PmnEj6ZVNwxW2iE6Npb
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6102:2929:b0:48f:137a:78b2 with
 SMTP id ada2fe7eead31-490321d3690mr113577137.5.1720654965123; Wed, 10 Jul
 2024 16:42:45 -0700 (PDT)
Date: Wed, 10 Jul 2024 23:42:11 +0000
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240710234222.2333120-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240710234222.2333120-8-jthoughton@google.com>
Subject: [RFC PATCH 07/18] KVM: Provide attributes to kvm_arch_pre_set_memory_attributes
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

This is needed so that architectures can do the right thing (including
at least unmapping newly userfault-enabled gfns) when KVM Userfault is
enabled for a particular range.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 840e02c75fe3..77eb9f0de02d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2514,6 +2514,7 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	struct kvm_mmu_notifier_range pre_set_range = {
 		.start = start,
 		.end = end,
+		.arg.attributes = attributes,
 		.handler = kvm_pre_set_memory_attributes,
 		.on_lock = kvm_mmu_invalidate_begin,
 		.flush_on_ret = true,
-- 
2.45.2.993.g49e7a77208-goog

