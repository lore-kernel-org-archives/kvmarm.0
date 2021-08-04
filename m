Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A02C4338F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 09:15:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 77D9060FC4
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 09:15:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 77D9060FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 067504A49C;
	Wed,  4 Aug 2021 05:15:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id myg2UILU5ctf; Wed,  4 Aug 2021 05:15:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DDD984A4C0;
	Wed,  4 Aug 2021 05:15:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 782094A4A0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 05:15:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oS4Ipvf5VgVN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 05:15:01 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5ADD24A49C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 05:15:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628068501;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=tTIjprUhEDbhjonUuP4pIFp+Z7bPyJe6jb/7RK3byQs=;
 b=BXLyYJMqwHhQupu7TK0cCs+XEM34XPX5nlZNmAcSGIgIfjW7E9KfA1iw+kVZY/O5Bek1OQ
 ZdxN0+TYGTA9OtVRJyUJBQ9OoAFp3YOusFqmSj94gFkONMpWzobGZ1HO19mETx5kmatncO
 ND1nimQwS9475w7AEmLpCcJm8hVUeVc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-508-bvFFB9J3NfSC8y_kexqZmA-1; Wed, 04 Aug 2021 05:14:57 -0400
X-MC-Unique: bvFFB9J3NfSC8y_kexqZmA-1
Received: by mail-ed1-f70.google.com with SMTP id
 u25-20020aa7d8990000b02903bb6a903d90so1127711edq.17
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 02:14:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=tTIjprUhEDbhjonUuP4pIFp+Z7bPyJe6jb/7RK3byQs=;
 b=B1B2A69ZI6NxwvovsuK3v/xkfYc4sXxxWoGieqN5U+97NVeZMwiVJ0wK2zFoyV5s6F
 CwUOsx/YEuV5KFT2HqrQjt6Zctm/wdfPjxBxb5l8by+cXCo3qgatnR0Av+8lhYLkjpDa
 6kW0fIp5tFthG98FfUs4x5UJjmof4HBv0VEnqc2BjlOX8IHbsZsVhNMkMPubiHJ7Qezo
 NxnY2cg7hYGKo2B3t6uYbdUd0APb7Nj1tZ3RrCsCGqB6FVzyGS7ARdm+GbPJ86fYdRxC
 e3RURnQY4CTqWDYoQU+zhRkaBexKsupR/SlwQD2JgKVaEw9s02be/9pb5yp9lj2hNj3f
 b9fA==
X-Gm-Message-State: AOAM532QaQcqkcaHmmzzZ1NaDoZ4WB1JtU8TvdkvuZdDivy31DfM+sdr
 5q92ju+/Fts6y3OpQJ7lEo7MqEMl5aXUdumdvQb+CEG2ZX0GyoGjwWnJe1l7A+oxwbM6XSkLFpj
 ZTHtKvxNsO8AewiYtqtxXuyf6
X-Received: by 2002:a05:6402:40c7:: with SMTP id
 z7mr2271222edb.193.1628068496559; 
 Wed, 04 Aug 2021 02:14:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzq8BjCcunO2gxZ/evsJ4buvf+QSwB0JER9NnDit3gYvyU1ktgpjUANRe5hzZ0BF++uILOjA==
X-Received: by 2002:a05:6402:40c7:: with SMTP id
 z7mr2271190edb.193.1628068496402; 
 Wed, 04 Aug 2021 02:14:56 -0700 (PDT)
Received: from gator.home (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
 by smtp.gmail.com with ESMTPSA id i14sm690894edx.30.2021.08.04.02.14.55
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 04 Aug 2021 02:14:55 -0700 (PDT)
Date: Wed, 4 Aug 2021 11:14:53 +0200
From: Andrew Jones <drjones@redhat.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v6 14/21] selftests: KVM: Add helper to check for
 register presence
Message-ID: <20210804091453.u4bf75pfeyldowt5@gator.home>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-15-oupton@google.com>
MIME-Version: 1.0
In-Reply-To: <20210804085819.846610-15-oupton@google.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Raghavendra Rao Anata <rananta@google.com>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, Aug 04, 2021 at 08:58:12AM +0000, Oliver Upton wrote:
> The KVM_GET_REG_LIST vCPU ioctl returns a list of supported registers
> for a given vCPU. Add a helper to check if a register exists in the list
> of supported registers.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  .../testing/selftests/kvm/include/kvm_util.h  |  2 ++
>  tools/testing/selftests/kvm/lib/kvm_util.c    | 19 +++++++++++++++++++
>  2 files changed, 21 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
> index 1b3ef5757819..077082dd2ca7 100644
> --- a/tools/testing/selftests/kvm/include/kvm_util.h
> +++ b/tools/testing/selftests/kvm/include/kvm_util.h
> @@ -215,6 +215,8 @@ void vcpu_fpu_get(struct kvm_vm *vm, uint32_t vcpuid,
>  		  struct kvm_fpu *fpu);
>  void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid,
>  		  struct kvm_fpu *fpu);
> +
> +bool vcpu_has_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t reg_id);
>  void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
>  void vcpu_set_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg);
>  #ifdef __KVM_HAVE_VCPU_EVENTS
> diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> index 0fe66ca6139a..a5801d4ed37d 100644
> --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> @@ -1823,6 +1823,25 @@ void vcpu_fpu_set(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_fpu *fpu)
>  		    ret, errno, strerror(errno));
>  }
>  
> +bool vcpu_has_reg(struct kvm_vm *vm, uint32_t vcpuid, uint64_t reg_id)
> +{
> +	struct kvm_reg_list *list;
> +	bool ret = false;
> +	uint64_t i;
> +
> +	list = vcpu_get_reg_list(vm, vcpuid);
> +
> +	for (i = 0; i < list->n; i++) {
> +		if (list->reg[i] == reg_id) {
> +			ret = true;
> +			break;
> +		}
> +	}
> +
> +	free(list);
> +	return ret;
> +}
> +
>  void vcpu_get_reg(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_one_reg *reg)
>  {
>  	int ret;
> -- 
> 2.32.0.605.g8dce9f2422-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
