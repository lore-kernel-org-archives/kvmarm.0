Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AF64C43461
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 04:22:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9E55561244
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 04:22:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9E55561244
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F7254B77A;
	Thu, 20 May 2021 00:22:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Bk03YsOhO4G1; Thu, 20 May 2021 00:21:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F82A4B7F6;
	Thu, 20 May 2021 00:21:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61EF44B7DB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 00:21:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bE-q8bH-MnH6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 00:21:56 -0400 (EDT)
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com
 [209.85.210.170])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EF1BC4B5C6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 00:21:55 -0400 (EDT)
Received: by mail-pf1-f170.google.com with SMTP id g18so9761974pfr.2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 May 2021 21:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=DoLjvzR9Ycpjqcta0VpSiJR4Bdnq46dPXdEKwxdkZyE=;
 b=KhAuP9uJ0n9pmyTFOxYfvk0m31c9RU1ZSXij+ksAklnEMQOxYzFB8F2NghHrxa0v/q
 wL/kdDf2JVSyJJnvOnZAZnOHIQwbe3g3IwaONeGKzObQDxihAExXUsj1UNM+FeUaxaCB
 cs3C6C6BObrMp27EBsoNGKxVfSeEpoLskJddVXnFZCV4+9TX18AgZvLNSOzUDsw9nUkg
 P0OgZzuc4/aPq+MHVU37o5Rsxp6/Gh/tbpXovUKYmvQmUWUws3uSDkvk9k13v3DQr1VX
 qJrP3ehBjk3P/TTsuttFjfSyzxtdq7PiNymDcP30iofWSZVHWs4jHZoUb0uN7/oXndKL
 vkZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=DoLjvzR9Ycpjqcta0VpSiJR4Bdnq46dPXdEKwxdkZyE=;
 b=TviKSZJZQxAKaVbqo7ukt7Ti6ACj4X1/cCWOkPPQvFmCrQnHvSR4mLQp7T+kYZw25K
 POMtoerrlABCFEEoKxSi+TkfYj3UWe7tAWESmAiCFFavPW5KbN30Rj/+1IFhIPqWA2Mp
 Xf+qhb729KHQsiGW4aMFo680sx0VSrT0SJ3GC6nggPb2+ABxPAUlnfNpbs9gZoAq2UuO
 lmAA0YqJCGXqxmkYNvrUCuu5A0d0MWe4hnwY+OFnaCUpNVm3/+RfHGgfUlhrgELrGLBK
 /xftdtSobNGN8zmeIQ1uyz0QYDYhhaQcZPYUoU7GdqxshnUAPg/TAO71uGI6mgT8xzoB
 0fqQ==
X-Gm-Message-State: AOAM531Tp08Zm5l8ge76y/ciTxOnSq6AeAwKhKRmft7v3awW4idOb8Zs
 MywWGgUo7sFQ57qzpKF/7Q/hDQ==
X-Google-Smtp-Source: ABdhPJyUT/W5KKf6QPkIVjnToQh3ryfQCsYn+WRFe/r3PlLYmoitMteeLZgd2ATqkGcuRlOqcbdSDw==
X-Received: by 2002:a62:860b:0:b029:28e:d45b:4d2e with SMTP id
 x11-20020a62860b0000b029028ed45b4d2emr2616829pfd.70.1621484514603; 
 Wed, 19 May 2021 21:21:54 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id j23sm738541pfh.179.2021.05.19.21.21.53
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 19 May 2021 21:21:53 -0700 (PDT)
Date: Wed, 19 May 2021 21:21:50 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v5 2/4] KVM: stats: Add fd-based API to read binary stats
 data
Message-ID: <YKXj3gHvUoLnojzB@google.com>
References: <20210517145314.157626-1-jingzhangos@google.com>
 <20210517145314.157626-3-jingzhangos@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210517145314.157626-3-jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, LinuxMIPS <linux-mips@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Mon, May 17, 2021 at 02:53:12PM +0000, Jing Zhang wrote:
> Provides a file descriptor per VM to read VM stats info/data.
> Provides a file descriptor per vCPU to read vCPU stats info/data.
> 
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/kvm/guest.c    |  26 +++++
>  arch/mips/kvm/mips.c      |  52 +++++++++
>  arch/powerpc/kvm/book3s.c |  52 +++++++++
>  arch/powerpc/kvm/booke.c  |  45 ++++++++
>  arch/s390/kvm/kvm-s390.c  | 117 ++++++++++++++++++++
>  arch/x86/kvm/x86.c        |  53 +++++++++
>  include/linux/kvm_host.h  | 127 ++++++++++++++++++++++
>  include/uapi/linux/kvm.h  |  50 +++++++++
>  virt/kvm/kvm_main.c       | 223 ++++++++++++++++++++++++++++++++++++++
>  9 files changed, 745 insertions(+)
> 
  
> +static ssize_t kvm_vcpu_stats_read(struct file *file, char __user *user_buffer,
> +			      size_t size, loff_t *offset)
> +{
> +	char id[KVM_STATS_ID_MAXLEN];
> +	struct kvm_vcpu *vcpu = file->private_data;
> +	ssize_t copylen, len, remain = size;
> +	size_t size_header, size_desc, size_stats;
> +	loff_t pos = *offset;
> +	char __user *dest = user_buffer;
> +	void *src;

Nit. Better to do pointer arithmetic on a "char *".  Note that gcc and
clang will do the expected thing.

> +
> +	snprintf(id, sizeof(id), "kvm-%d/vcpu-%d",
> +			task_pid_nr(current), vcpu->vcpu_id);
> +	size_header = sizeof(kvm_vcpu_stats_header);
> +	size_desc =
> +		kvm_vcpu_stats_header.count * sizeof(struct _kvm_stats_desc);
> +	size_stats = sizeof(vcpu->stat);
> +
> +	len = sizeof(id) + size_header + size_desc + size_stats - pos;
> +	len = min(len, remain);
> +	if (len <= 0)
> +		return 0;
> +	remain = len;

If 'desc_offset' is not right after the header, then the 'len'
calculation is missing the gap into account. For example, assuming there
is a gap of 0x1000000 between the header and the descriptors:

	desc_offset = sizeof(id) + size_header + 0x1000000

and the user calls the ioctl with enough space for the whole file,
including the gap:

	*offset = 0
	size = sizeof(id) + size_header + size_desc + size_stats + 0x1000000

then 'remain' gets the wrong size:

	remain = sizeof(id) + size_header + size_desc + size_stats

and ... (more below)

> +
> +	/* Copy kvm vcpu stats header id string */
> +	copylen = sizeof(id) - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = (void *)id + pos;
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}
> +	/* Copy kvm vcpu stats header */
> +	copylen = sizeof(id) + size_header - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = (void *)&kvm_vcpu_stats_header;
> +		src += pos - sizeof(id);
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}
> +	/* Copy kvm vcpu stats descriptors */
> +	copylen = kvm_vcpu_stats_header.desc_offset + size_desc - pos;

This would be the state at this point:

	pos	= sizeof(id) + size_header
	copylen	= sizeof(id) + size_header + 0x1000000 + size_desc - (sizeof(id) + size_header)
		= 0x1000000 + size_desc
	remain	= size_desc + size_stats

> +	copylen = min(copylen, remain);

	copylen = size_desc + size_stats

which is not enough to copy the descriptors (and the data).

> +	if (copylen > 0) {
> +		src = (void *)&kvm_vcpu_stats_desc;
> +		src += pos - kvm_vcpu_stats_header.desc_offset;

Moreover, src also needs to take the gap into account.

	src	= &kvm_vcpu_stats_desc + (sizeof(id) + size_header) - (sizeof(id) + size_header + 0x1000000)
		= &kvm_vcpu_stats_desc - 0x1000000

Otherwise, src ends up pointing at the wrong place.

> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}
> +	/* Copy kvm vcpu stats values */
> +	copylen = kvm_vcpu_stats_header.data_offset + size_stats - pos;

The same problem occurs here. There is a potential gap before
data_offset that needs to be taken into account for src and len.

Would it be possible to just ensure that there is no gap? maybe even
remove data_offset and desc_offset and always place them adjacent, and
have the descriptors right after the header.

> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = (void *)&vcpu->stat;
> +		src += pos - kvm_vcpu_stats_header.data_offset;
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}
> +
> +	*offset = pos;
> +	return len;
> +}
> +
>  



> +static ssize_t kvm_vm_stats_read(struct file *file, char __user *user_buffer,
> +			      size_t size, loff_t *offset)
> +{

Consider moving the common code between kvm_vcpu_stats_read and this one
into some function that takes pointers to header, desc, and data. Unless
there is something vcpu or vm specific besides that.

> +	char id[KVM_STATS_ID_MAXLEN];
> +	struct kvm *kvm = file->private_data;
> +	ssize_t copylen, len, remain = size;
> +	size_t size_header, size_desc, size_stats;
> +	loff_t pos = *offset;
> +	char __user *dest = user_buffer;
> +	void *src;
> +
> +	snprintf(id, sizeof(id), "kvm-%d", task_pid_nr(current));
> +	size_header = sizeof(kvm_vm_stats_header);
> +	size_desc = kvm_vm_stats_header.count * sizeof(struct _kvm_stats_desc);
> +	size_stats = sizeof(kvm->stat);
> +
> +	len = sizeof(id) + size_header + size_desc + size_stats - pos;
> +	len = min(len, remain);
> +	if (len <= 0)
> +		return 0;
> +	remain = len;
> +
> +	/* Copy kvm vm stats header id string */
> +	copylen = sizeof(id) - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = (void *)id + pos;
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}
> +	/* Copy kvm vm stats header */
> +	copylen = sizeof(id) + size_header - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = (void *)&kvm_vm_stats_header;
> +		src += pos - sizeof(id);
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}
> +	/* Copy kvm vm stats descriptors */
> +	copylen = kvm_vm_stats_header.desc_offset + size_desc - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = (void *)&kvm_vm_stats_desc;
> +		src += pos - kvm_vm_stats_header.desc_offset;
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}
> +	/* Copy kvm vm stats values */
> +	copylen = kvm_vm_stats_header.data_offset + size_stats - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = (void *)&kvm->stat;
> +		src += pos - kvm_vm_stats_header.data_offset;
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}
> +
> +	*offset = pos;
> +	return len;
> +}
> +
> -- 
> 2.31.1.751.gd2f1c929bd-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
