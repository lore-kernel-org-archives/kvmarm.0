Return-Path: <SRS0=srdq=LL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28A5CC2B9F4
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 07:24:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A13056135C
	for <kvmarm@archiver.kernel.org>; Thu, 17 Jun 2021 07:24:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A13056135C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AAB240870;
	Thu, 17 Jun 2021 03:24:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linuxfoundation.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Acz13U+9F-DC; Thu, 17 Jun 2021 03:24:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51D7449DE7;
	Thu, 17 Jun 2021 03:24:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E92AE40874
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 03:24:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nJxE-kX20rn8 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Jun 2021 03:24:32 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9B77B40870
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Jun 2021 03:24:32 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5C0A61241;
 Thu, 17 Jun 2021 07:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
 s=korg; t=1623914671;
 bh=kNxTxEwPcYv3NN2DfpZ8GnBN8QRikI5mGsAdJMShdj8=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=vmjn0HbF4vDkLycAFVfFgocX33s32jQVUNaGP0J3DSVKZAgg2IaQrobYDvDawDma7
 x3ikJMr5SuhJwFPLP6HEpPDeER5nEM2UPQEAeKtSe//vF6YDonr90WBlk5yNgc90ZN
 Ffb7TLPNWmUzQseIO/Xbs7cENsIfzLUJos/2MPo0=
Date: Thu, 17 Jun 2021 09:24:28 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v10 2/5] KVM: stats: Add fd-based API to read binary
 stats data
Message-ID: <YMr4rArKvj3obDEM@kroah.com>
References: <20210617044146.2667540-1-jingzhangos@google.com>
 <20210617044146.2667540-3-jingzhangos@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210617044146.2667540-3-jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linuxkselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVMARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 LinuxS390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVMPPC <kvm-ppc@vger.kernel.org>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 David Matlack <dmatlack@google.com>, Jim Mattson <jmattson@google.com>,
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

On Thu, Jun 17, 2021 at 04:41:43AM +0000, Jing Zhang wrote:
> Provides a file descriptor per VM to read VM stats info/data.
> Provides a file descriptor per vCPU to read vCPU stats info/data.

Shouldn't this be two separate patches, one for each thing as these are
two different features being added?

Anyway, an implementation question for both of these:

> +static ssize_t kvm_stats_read(struct _kvm_stats_header *header,
> +		struct _kvm_stats_desc *desc, void *stats, size_t size_stats,
> +		char __user *user_buffer, size_t size, loff_t *offset)
> +{
> +	ssize_t copylen, len, remain = size;

You are "burying" the fact that remain is initialized here, not nice, I
totally missed it when reading this the first time.

This should be:
	ssize_t copylen;
	ssize_t len;
	ssize_t remain = size;
to be obvious.

Remember you will be looking at this code for the next 20 years, make it
easy to read.

> +	size_t size_header, size_desc;
> +	loff_t pos = *offset;
> +	char __user *dest = user_buffer;
> +	void *src;
> +
> +	size_header = sizeof(*header);
> +	size_desc = header->header.count * sizeof(*desc);
> +
> +	len = size_header + size_desc + size_stats - pos;
> +	len = min(len, remain);
> +	if (len <= 0)
> +		return 0;
> +	remain = len;
> +
> +	/* Copy kvm stats header */
> +	copylen = size_header - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = (void *)header + pos;
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}

I thought you said that you would not provide the header for each read,
if you keep reading from the fd.  It looks like you are adding it here
to each read, or is there some "magic" with pos happening here that I do
not understand?

And if there is "magic" with pos, you should document it as it's not
very obvious :)

> +	/* Copy kvm stats descriptors */
> +	copylen = header->header.desc_offset + size_desc - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = (void *)desc + pos - header->header.desc_offset;
> +		if (copy_to_user(dest, src, copylen))
> +			return -EFAULT;
> +		remain -= copylen;
> +		pos += copylen;
> +		dest += copylen;
> +	}
> +	/* Copy kvm stats values */

New lines between code blocks of doing things?

And again, why copy the decriptor again?  or is it being skipped
somehow?  Ah, I think I see how it's being skipped, if I look really
closely.  But again, it's not obvious, and I could be wrong.  Please
document this REALLY well.

Write code for the developer first, compiler second.  Again, you are
going to be maintaining it for 20+ years, think of your future self...


> +	copylen = header->header.data_offset + size_stats - pos;
> +	copylen = min(copylen, remain);
> +	if (copylen > 0) {
> +		src = stats + pos - header->header.data_offset;
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

thanks,

greg k-h
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
