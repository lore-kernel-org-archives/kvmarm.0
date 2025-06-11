Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A12255E20
	for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 22:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749682094; cv=none; b=M/ak71q9UQxGm85yq5sw4QRR9Ntcx7HXjYAV5O1+BLgUDoLJ947p0LcIOkHyQuhYs7uJT9iC6iqEBW7MjGONJQpyYPgdgYSsPQxaDZMfK5o9ejgDXkz97PkeIvqFcpc1odY/59KZqd3ouauxINFVevwsr6O3rX8uTNbEsNMckGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749682094; c=relaxed/simple;
	bh=yZZtRbcWnuqwQyat4VhI1SVpbjBljsz8F13Q0oWxmXQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LO2Lbn85WX3qmQSabAC0HVhSUMDpPN7Ct8iq+QcILdqK6oi6ArwOMr/sgtZ6vYEIgV7XQN2DteJO/A+P7EjG9C6uiu3R89u3rmZDk0kKsihEm9AwUj4dltgi2C0j/6GB/nyXijvymSfNpRxi7tphiOmGIxiO32DG9BS+4xpdHJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IxIPxEJa; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IxIPxEJa"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3132e7266d3so340391a91.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Jun 2025 15:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749682092; x=1750286892; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=mEZsLhf6SxJ64ydA6t/wQOktcm5LeFVwzcPjAJ4nCGM=;
        b=IxIPxEJaWFn7VbWht/QDOl9A9SCftW+9RQqQAuOgnMetNC7Mlv/HBqV0v9VQ5DaG6D
         8HYFH+yCsexFj1Dp7mynOuCzgq4mLeGphc6+OJid+XKPnFJl8pSmoOqNXPJw0bxJVBZk
         7Ii9yLtttXsfCBTuBhU10upKtwP58KtlIgAjDvzWdI8m83mhdd8iJPPguwFvtEb2lmUx
         vmdg7onUux5PmL5fMhLR6yTOxQ44OOdDfiScuw88AvD+vgnuTnmpOuV0wAUsD3Otu4gW
         zNsC68sDrSmn/Xv74GDqkLdCaghzFViag4BuFy8FQvjz3C/fh+ROiyNNwgrt5bn5cwLr
         hWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749682092; x=1750286892;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mEZsLhf6SxJ64ydA6t/wQOktcm5LeFVwzcPjAJ4nCGM=;
        b=gE9Er5z54rYbBGLnfQy/j6B50qxDeEgEO1SGTmuYqalDQB07+wY3i5okznqYZqm27I
         ifmcwKxpptc33g7BnF142yjYyje2+sKRq6NMpaweT7J7lWUUoQQyD8xAZIMnWps8ErNF
         PmSqSP2pzfcmXhX+glOwqeJgUJMxvJP2upuzzillulNqha5jsr78gF1G+INieO3wzJCQ
         hh8biGH57LT74zI/ECJVape3o72WYI0plU0k9WPQUyAP6LgisM0RCSRW90WtpsNHp0B6
         emr6gG/eC8dj139XXpzebxSQdoSxD854q6ilmxFj+UcQ7UI9Cy6tuphdCeWskn2J/nbc
         Ovkw==
X-Forwarded-Encrypted: i=1; AJvYcCUq20ZsK2N6Ud54VJ42Fc9A8Aq4v1cR7Z1kmoiZiSh4F0hu8uNVriTkX9yX/pJHH1St/bHOW+M=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAU7hqVokA5VR3KxNaQ1EAoQedZiX+MB0sgtT2cfZ77DZZ6svr
	CGwS8tOGbp3gfLGwLjq2d4L2nI24UCAVhSB6YYIpFojZ0erQDGrD0iQRizqxTVAcL/Xa6WW6UbS
	Y394bUQ==
X-Google-Smtp-Source: AGHT+IFg24zPNL3KiBl4z/DNOHqd2KhvvGrjl3yLgrTD6GwXkCuqSf7mQ8rAwENd7T74FPlQ31IQOCRlfVY=
X-Received: from pjwx3.prod.google.com ([2002:a17:90a:c2c3:b0:2fc:c98:ea47])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c2d0:b0:312:def0:e2dc
 with SMTP id 98e67ed59e1d1-313c068d18amr1292249a91.7.1749682091962; Wed, 11
 Jun 2025 15:48:11 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 11 Jun 2025 15:45:47 -0700
In-Reply-To: <20250611224604.313496-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <20250611224604.313496-46-seanjc@google.com>
Subject: [PATCH v3 44/62] KVM: SVM: Don't check for assigned device(s) when
 updating affinity
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't bother checking if a VM has an assigned device when updating AVIC
vCPU affinity, querying ir_list is just as cheap and nothing prevents
racing with changes in device assignment.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 2e3a8fda0355..dadd982b03c0 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -847,9 +847,6 @@ static inline int avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu
 
 	lockdep_assert_held(&svm->ir_list_lock);
 
-	if (!kvm_arch_has_assigned_device(vcpu->kvm))
-		return 0;
-
 	/*
 	 * Here, we go through the per-vcpu ir_list to update all existing
 	 * interrupt remapping table entry targeting this vcpu.
-- 
2.50.0.rc1.591.g9c95f17f64-goog

