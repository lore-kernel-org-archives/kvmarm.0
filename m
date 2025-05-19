Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08B5720FAB6
	for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 18:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747680924; cv=none; b=eiHqMh7w8/6Q66JDnHuElztrUiFGySn2Hrk/agRlMZXaM7jKZbBmHoyD9HWJ30Azud9rP3dhNII1RsRV+1PzdBPa7/nm2XOjO6e0nhaEUA+WzEdRCTxNBH9X9JxbHfC7CJ4NKYjguuveVPj9Tn47zfhggEZZ0wN7O09scxHFYHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747680924; c=relaxed/simple;
	bh=YEjJ+gCdMZpQ1F4rNk5UqTqRmHjDj6r7FHrcRYcEQlk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=c/hgcepV5arLx03OlmSXHBCc7XVh0j2rng0nuOkA688rlNCpSki/jklCy0jm7sH3LuXVyu/pAdM9ldTaJ5Uxc+ErFcGVdfj0oRyhp/Esz00GHEjRDN8TT9jWSkgRtYGuavucmWzlkrazwJJBsJNm8Cs0kVrJMUT/tMTyaInFrLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w+L8hnYJ; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w+L8hnYJ"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b26e0fee459so2862187a12.1
        for <kvmarm@lists.linux.dev>; Mon, 19 May 2025 11:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747680922; x=1748285722; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=EvW/ttC5JRh/LPYdQJ6J3cVAwkFh6wSGOl9jEVKaPhQ=;
        b=w+L8hnYJULG3igDpxNonyghGj6t8H6BRFfgiyM28CYOJJudCrt8BJyr/nEvX6gF5G7
         7MXlIQ0kcXpGeuf8etNmHgJPgjMSX+8GnHhZMdpxp4P2I4QamM2p/K/YPMDL4Fv1bL1t
         Q80nVbEsjsuDWmHiBuyJFIl3bTQvHtRTbPz3lsfHWzG0AIajrKXz+UmJDCCHn0gSXm1k
         3pOgASo7HhoZSBmOojMe2oIu/Wah5VqozcF+mtIzrvEHfdfMyDk4BV4ptwFTBI2N1DyX
         SRhERUySCPXcUfW2GdhGhN5yUW247ukwblN/36PNRhcAx+KKtjnegvpccpKRbZHHIi7A
         uLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747680922; x=1748285722;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EvW/ttC5JRh/LPYdQJ6J3cVAwkFh6wSGOl9jEVKaPhQ=;
        b=A2dq2tpJfOFxVXymq7qyeNgS6Hgoydkp3fqC97BS6hBjmX7SHHrQgfpn7RzXtJJ5R7
         QdaXshyZ3+N6GJKpzqIYMHcIQhCQFJtTXPDBTv36hi/1yi3GNAr3GGbV0ZEtexlZ4GLv
         yfCjLBEz9D6OSUe3GvIzO2HRM8xUUgQHblOO3GHC0+lWLN5qL0yjVAPxWH7bPv5sMqe0
         ESY9Xi4DgDTG/6TwJ4dOKT3R01zo/rodJd60wZBkkhfFRbXvU3HZdJQlkecH19Uzxibe
         6ktycrIclcdvRRI6izcQ+IzjhRjRqUo4I5mcr/2EoedaKtIUJzk+fYe3VDrJLb82FaOK
         W9fw==
X-Forwarded-Encrypted: i=1; AJvYcCXD3YP14JJEM41cZKpMPU/XyfkzBUyJYtLKYXDHLgDsxYdPg6uP2BJM0/UQzMZiESHm/eqTLuk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/rxL7vAqjRSO9+UpIIHJzzfFzjR1FIwVXsxHj+j8VUWcF+MxY
	mp7g9M9I8C8gIxF+pyahv+bJo7p1HBJDxLE1kzJrfZTheQAkBPMamaPwuow1sEPqVpBo3x9Wf4g
	9cU9Y0g==
X-Google-Smtp-Source: AGHT+IH9JoaEOfOB8zI2vxbbMIYbrh+JbpOCKy1k7VOcQtUTf5dKAMywqOhhzpJYNuTO32YplhBdVZbLjmE=
X-Received: from pliy13.prod.google.com ([2002:a17:903:3d0d:b0:223:4788:2e83])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2986:b0:232:2b90:1410
 with SMTP id d9443c01a7336-2322b901585mr92377195ad.10.1747680922171; Mon, 19
 May 2025 11:55:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 19 May 2025 11:55:04 -0700
In-Reply-To: <20250519185514.2678456-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250519185514.2678456-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1101.gccaa498523-goog
Message-ID: <20250519185514.2678456-3-seanjc@google.com>
Subject: [PATCH v2 02/12] KVM: Acquire SCRU lock outside of irqfds.lock during assignment
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	K Prateek Nayak <kprateek.nayak@amd.com>, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Acquire SRCU outside of irqfds.lock so that the locking is symmetrical,
and add a comment explaining why on earth KVM holds SRCU for so long.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/eventfd.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
index 39e42b19d9f7..42c02c35e542 100644
--- a/virt/kvm/eventfd.c
+++ b/virt/kvm/eventfd.c
@@ -401,6 +401,18 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	 */
 	init_waitqueue_func_entry(&irqfd->wait, irqfd_wakeup);
 
+	/*
+	 * Set the irqfd routing and add it to KVM's list before registering
+	 * the irqfd with the eventfd, so that the routing information is valid
+	 * and stays valid, e.g. if there are GSI routing changes, prior to
+	 * making the irqfd visible, i.e. before it might be signaled.
+	 *
+	 * Note, holding SRCU ensures a stable read of routing information, and
+	 * also prevents irqfd_shutdown() from freeing the irqfd before it's
+	 * fully initialized.
+	 */
+	idx = srcu_read_lock(&kvm->irq_srcu);
+
 	spin_lock_irq(&kvm->irqfds.lock);
 
 	ret = 0;
@@ -409,11 +421,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 			continue;
 		/* This fd is used for another irq already. */
 		ret = -EBUSY;
-		spin_unlock_irq(&kvm->irqfds.lock);
-		goto fail;
+		goto fail_duplicate;
 	}
 
-	idx = srcu_read_lock(&kvm->irq_srcu);
 	irqfd_update(kvm, irqfd);
 
 	list_add_tail(&irqfd->list, &kvm->irqfds.items);
@@ -449,6 +459,9 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
 	srcu_read_unlock(&kvm->irq_srcu, idx);
 	return 0;
 
+fail_duplicate:
+	spin_unlock_irq(&kvm->irqfds.lock);
+	srcu_read_unlock(&kvm->irq_srcu, idx);
 fail:
 	if (irqfd->resampler)
 		irqfd_resampler_shutdown(irqfd);
-- 
2.49.0.1101.gccaa498523-goog

