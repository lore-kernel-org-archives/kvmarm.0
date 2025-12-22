Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11C72D12F1
	for <kvmarm@lists.linux.dev>; Mon, 22 Dec 2025 14:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766412569; cv=none; b=Kz4LX1snz7zZZXFhbs8wFr5SWGUHXfDpnmBMpZc8CvedBu6Y4F4R7jk9g6RGbvJa7V6592L7pLNLeH4VPjI9GATUR1AUyRtsh1QRjWVJazTwIUuz9Nu8MrjwLYVUONbIjM6TMfvUj7hYQ5CZmwldykJgg8HnWjyI12pdyIYhqdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766412569; c=relaxed/simple;
	bh=p/i6kMwISrCPM6iQXn0HaSNUzgsyoLTxQlFLGZ2uzQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eDkoYcYkwP8OZ/zySmDQwdfsaxOBtntQt7cIf5oLiZYSgAMu3qi1DunrTGeeWtSU4Z9iVOMIAc9kxMiQR4N1aiMSfTAMNN9EjkRzYicBRFnn7KvaAVBetT/OD80JC6TTFyAwSvMJ9uVnJ1Itg5QtNlHQ1SJ8GSfuKRaNRUf99gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LwVIG02C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LwVIG02C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766412566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k1FE0+YEZR+tBzsGFvPzgiyYjR1CkUcfeInMhZI6Of8=;
	b=LwVIG02C/S6Jn+gmpubXJQyy0PUGcGjvbODhNpXmZ3MYf5wXJzD8T/934JQj0ANgkNmLPw
	lM8AFut3rKyIsO2+qXRd67jZXAxfQldZsRru9FUWUMIHiRY6fESm0XkYHptRxfvVUKQNJ0
	L6wsXa3nW2CVWT/UrRStwXWYsr7AHGA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-Zk7KKmYjOsSFsa9Cj0py6w-1; Mon, 22 Dec 2025 09:09:23 -0500
X-MC-Unique: Zk7KKmYjOsSFsa9Cj0py6w-1
X-Mimecast-MFC-AGG-ID: Zk7KKmYjOsSFsa9Cj0py6w_1766412562
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-430fd96b2f5so3497144f8f.3
        for <kvmarm@lists.linux.dev>; Mon, 22 Dec 2025 06:09:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766412562; x=1767017362;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1FE0+YEZR+tBzsGFvPzgiyYjR1CkUcfeInMhZI6Of8=;
        b=O9Mz9JVhyg24zJjmDrURo0NuQXZbBxEBNrS84qVxpVDGNe8M1G7eEaWzOmQ4n72fsI
         o3Qxw65SfQ6Exiok+urc0iAHZjOQaGSOzuQyMZAK3bZ296wERwcdIFCe2CnXE4A1LIKb
         E5Oyw4WRlKVHAnxenz6ALIiZgxbAp96KGZl10jDnYTRXkCj31qYJ5280JQ2+9XNgjM7h
         nyyU8qCsvk0yaaDfeXMmJXOh0gn9DcE0uC9CpipMadZUHeNVrc69an3SuI0Hs1SxYu6r
         Vxa2aos6oIAms1KKyRexFCLCvl2VupZmS0qm9CA/uM/mtLctbGS00Jzf5qjjhZFIQEY8
         dJ6w==
X-Forwarded-Encrypted: i=1; AJvYcCXXw+Mek8YrULfxNoVl8Wl1qJjmFCerpvZNAK+x2Kd8MSL7FcKRJ7K5mZEBIE6IULV4sTgtxls=@lists.linux.dev
X-Gm-Message-State: AOJu0YyljU5BmQe15oQ74UPgrmB0fKT3glfNb6MZeLDqlL33G7smLTyZ
	KSD5ZO0/5Bzte5Jay0ccishl1Xx3NyhBd03hxR93Z3gTwdX756O66Eu3Nj9Nac0kr8b417rIv13
	2RxNcLovRsAVulsR7q1/kMtKSsLiiP41SZDJGrpDPh969KGiMn+58wBRcPQ==
X-Gm-Gg: AY/fxX7QnidrD5y9/8m6dznDgdGWjvsRlsIOd4Cz2jqtr+5bajUNZxh+gFKzI1m5cq6
	FW1YgDh+s47Ix3chkIa3SewJHfWuMZTp89To0rCSPb3gz9uwAc+I0pR9xIImRlMNo+Hes5DwTAu
	x3SzmgU8DjIsYJmqL+UUTrxb31WgbgO8Ad3VA0ZRFXMeyPt71L4IiR64cu/u1h017whINH5khxQ
	LN4B6U1Q4yHWxQxR3aIsDtRaR5nZQHXwZ1R7BKBGnZMqnbFwXUyBYfFKajXMdTRfO8WF+NJpPW1
	wzbk8YMzECt5Pj1uE2DBi4NG2nHkxUIKW3f5h2n1px5sE3/Jk4qbfpHDEjK7VClHd+KzdJdIEYQ
	I0YX5XDppiSZBmFko2/ECQxSbysPNY2UCxirdK29RDruVTMrBDxFQP5HvNs4GaP85Eu8GhByCnh
	Pyj+L/qzJE/25UaOw=
X-Received: by 2002:a05:6000:290b:b0:42f:f627:3a99 with SMTP id ffacd0b85a97d-4324e4fd929mr14060416f8f.38.1766412561917;
        Mon, 22 Dec 2025 06:09:21 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGP6HMp+dW+4S6ThYyhC4Zp8b5zu9Tx+uPg89UKRyiU9jj0V1LJEfNM5y7cCeqmYyTSzw3qRw==
X-Received: by 2002:a05:6000:290b:b0:42f:f627:3a99 with SMTP id ffacd0b85a97d-4324e4fd929mr14060358f8f.38.1766412561414;
        Mon, 22 Dec 2025 06:09:21 -0800 (PST)
Received: from [192.168.10.48] ([151.95.145.106])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-4324eaa2beasm21799471f8f.33.2025.12.22.06.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 06:09:20 -0800 (PST)
Message-ID: <42513cb3-3c2e-4aa8-b748-23b6656a5096@redhat.com>
Date: Mon, 22 Dec 2025 15:09:13 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: possible deadlock due to irq_set_thread_affinity() calling into the
 scheduler (was Re: [PATCH v3 38/62] KVM: SVM: Take and hold ir_list_lock
 across IRTE updates in IOMMU)
To: Ankit Soni <Ankit.Soni@amd.com>, Sean Christopherson <seanjc@google.com>,
 Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, Joerg Roedel <joro@8bytes.org>,
 David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>,
 Maxim Levitsky <mlevitsk@redhat.com>,
 Joao Martins <joao.m.martins@oracle.com>,
 Francesco Lavra <francescolavra.fl@gmail.com>,
 David Matlack <dmatlack@google.com>, Naveen Rao <Naveen.Rao@amd.com>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-40-seanjc@google.com>
 <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <njhjud3e6wbdftzr3ziyuh5bhyvc5ndt5qvmg7rlvh5isoop2l@f2uxctws2c7d>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: IER3Lz4PyKPu5O4Eum0kEPfJl-MzrfqltvfNpO08qCs_1766412562
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 10:16, Ankit Soni wrote:
>    ======================================================
>    WARNING: possible circular locking dependency detected
>    6.19.0-rc2 #20 Tainted: G            E
>    ------------------------------------------------------
>    CPU 58/KVM/28597 is trying to acquire lock:
>      ff12c47d4b1f34c0 (&irq_desc_lock_class){-.-.}-{2:2}, at: __irq_get_desc_lock+0x58/0xa0
> 
>      but task is already holding lock:
>      ff12c49b28552110 (&svm->ir_list_lock){....}-{2:2}, at: avic_pi_update_irte+0x147/0x270 [kvm_amd]
> 
>      which lock already depends on the new lock.
> 
>    Chain exists of:
>      &irq_desc_lock_class --> &rq->__lock --> &svm->ir_list_lock
> 
>    Possible unsafe locking scenario:
> 
>          CPU0                            CPU1
>          ----                            ----
>     lock(&svm->ir_list_lock);
>                                        lock(&rq->__lock);
>                                        lock(&svm->ir_list_lock);
>     lock(&irq_desc_lock_class);
> 
>          *** DEADLOCK ***
> 
> So lockdep sees:
> 
>    &irq_desc_lock_class -> &rq->__lock -> &svm->ir_list_lock
> 
> while avic_pi_update_irte() currently holds svm->ir_list_lock and then
> takes irq_desc_lock via irq_set_vcpu_affinity(), which creates the
> potential inversion.
> 
>    - Is this lockdep warning expected/benign in this code path, or does it
>      indicate a real potential deadlock between svm->ir_list_lock and
>      irq_desc_lock with AVIC + irq_bypass + VFIO?

I'd treat it as a potential (if unlikely) deadlock:

(a) irq_set_thread_affinity triggers the scheduler via wake_up_process,
while irq_desc->lock is taken

(b) the scheduler calls into KVM with rq_lock taken, and KVM uses
ir_list_lock within __avic_vcpu_load/__avic_vcpu_put

(c) KVM wants to block scheduling for a while and uses ir_list_lock for
that purpose, but then takes irq_set_vcpu_affinity takes irq_desc->lock.

I don't think there's an alternative choice of lock for (c); and there's
no easy way to pull the irq_desc->lock out of the IRQ subsystem--in fact
the stickiness of the situation comes from rq->rq_lock and
irq_desc->lock being both internal and not leaf.

Of the three, the most sketchy is (a); notably, __setup_irq() calls
wake_up_process outside desc->lock.  Therefore I'd like so much to treat
it as a kernel/irq/ bug; and the simplest (perhaps too simple...) fix is
to drop the wake_up_process().  The only cost is extra latency on the
next interrupt after an affinity change.

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 8b1b4c8a4f54..fc135bd079a4 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -189,14 +189,10 @@ static void irq_set_thread_affinity(struct irq_desc *desc)
  	struct irqaction *action;
  
  	for_each_action_of_desc(desc, action) {
-		if (action->thread) {
+		if (action->thread)
  			set_bit(IRQTF_AFFINITY, &action->thread_flags);
-			wake_up_process(action->thread);
-		}
-		if (action->secondary && action->secondary->thread) {
+		if (action->secondary && action->secondary->thread)
  			set_bit(IRQTF_AFFINITY, &action->secondary->thread_flags);
-			wake_up_process(action->secondary->thread);
-		}
  	}
  }
  
Marc, what do you think?

Paolo

