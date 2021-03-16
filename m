Return-Path: <SRS0=Oq5u=IO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43018C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 17:55:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BC77D650DE
	for <kvmarm@archiver.kernel.org>; Tue, 16 Mar 2021 17:55:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BC77D650DE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 482F04B4C2;
	Tue, 16 Mar 2021 13:55:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GcKa5S1CX8uT; Tue, 16 Mar 2021 13:54:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C07B4B50E;
	Tue, 16 Mar 2021 13:54:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8646A4B4C2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 13:54:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iwOppIrXNVQO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Mar 2021 13:54:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A316A4B456
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 13:54:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1615917296;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=q+nIYLcJsbNrOQJXNJzvpf/dZa2SR4YCfI1fCwdaCUY=;
 b=WsvcAM/DVZVN+35RQG4SU18F0p3n/dpdLxLxWAAmKFjaqnh3e65gERW6qfIO7IqkCxJQ8q
 qGH3g4UIkk5SlcSS6KQOmSYkXOMz25ctOFCeD3iIaRz7PMkb+aczhGLtHdL3gNhmH9DLcY
 LB0dVH2+spXH+ePpC9hSAz8ozFvlNls=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-270-v1kyDyvbMjKLP_oZ3t_sEg-1; Tue, 16 Mar 2021 13:54:54 -0400
X-MC-Unique: v1kyDyvbMjKLP_oZ3t_sEg-1
Received: by mail-wm1-f72.google.com with SMTP id n2so9934023wmi.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Mar 2021 10:54:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:to:cc:references:from:subject:message-id:date
 :user-agent:mime-version:in-reply-to:content-language
 :content-transfer-encoding;
 bh=q+nIYLcJsbNrOQJXNJzvpf/dZa2SR4YCfI1fCwdaCUY=;
 b=gU6grwLIz31jSHx30tQeH7VHBxcnJ6em+7zHvvIboLeogw3wq+nRiInwMMGm90Q0Ji
 EtAjPpkJ1wiqtNKXS4poT4QR6/HcQSY6PLIOhqxNITXNE3aaKpCab1XT1Kesc99dpQFK
 EUYxoeWdNXeAtn5PZA3z/WX4oS2whJYDqon/njjvVM+SAvt4gG/Q3vtHc04kDMm2FRm2
 wS65awhstPkADNvXGYP9Rp3cQF2A8NVf633Aq+z67JBq2Dx16RB9jQrmEmKvnamkkCrX
 VsFVA/X3BWihkUwajRemElT6lkCndrsmhHzSyXivMsykLbfxtPher5SVAIAwjIWEa9+F
 g/dQ==
X-Gm-Message-State: AOAM5317Pl1sxpFsGZ79NuoHQo9RISnlLvzfJ12tXxE+jCdw/RL55vu+
 047+fobI/BJY5skVvEFWJyU/VFYbrVfnKCnQsx6fpIFrzD/FroMRI+UBWz+hQyPqQdWQJfGAwxG
 CwhBngQFz6Ng3RzmlQzscuPRD
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr100860wmk.30.1615917293707;
 Tue, 16 Mar 2021 10:54:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhx2jdBpeYlHU1yJBLoi471Tl00503kY5ZdmFFXsMHSMA2gpxqqBKYhTriICrO+/ourTLAQg==
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr100818wmk.30.1615917293485;
 Tue, 16 Mar 2021 10:54:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a?
 ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
 by smtp.gmail.com with ESMTPSA id s83sm7994wms.16.2021.03.16.10.54.51
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 16 Mar 2021 10:54:52 -0700 (PDT)
To: Jing Zhang <jingzhangos@google.com>
References: <20210310003024.2026253-1-jingzhangos@google.com>
 <20210310003024.2026253-4-jingzhangos@google.com>
 <bb03107c-a413-50da-e228-d338dd471fb3@redhat.com>
 <CAAdAUth0J6z7fFpOkkmzKc83Bj+MST-jhsZ0uU0iYdRcE_-gMA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [RFC PATCH 3/4] KVM: stats: Add ioctl commands to pull statistics
 in binary format
Message-ID: <26035a80-3cce-9872-ab1d-b25b5817d512@redhat.com>
Date: Tue, 16 Mar 2021 18:54:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <CAAdAUth0J6z7fFpOkkmzKc83Bj+MST-jhsZ0uU0iYdRcE_-gMA@mail.gmail.com>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=pbonzini@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: KVM <kvm@vger.kernel.org>, David Hildenbrand <david@redhat.com>,
 Paul Mackerras <paulus@ozlabs.org>,
 Linux kselftest <linux-kselftest@vger.kernel.org>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, Will Deacon <will@kernel.org>,
 KVM ARM <kvmarm@lists.cs.columbia.edu>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>,
 Linux S390 <linux-s390@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
 Oliver Upton <oupton@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 David Rientjes <rientjes@google.com>, KVM PPC <kvm-ppc@vger.kernel.org>,
 Jim Mattson <jmattson@google.com>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Sean Christopherson <seanjc@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, Linux MIPS <linux-mips@vger.kernel.org>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 15/03/21 23:31, Jing Zhang wrote:
> We are considering about how to create the file descriptor. It might be risky
> to create an extra fd for every vCPU. It will easily hit the fd limit for the
> process or the system for machines running a ton of small VMs.

You already have a file descriptor for every vCPU, but I agree that 
having twice as many is not very good.

> Looks like creating an extra file descriptor for every VM is a better option.
> And then we can check per vCPU stats through Ioctl of this VM fd by
> passing the vCPU index.

The file descriptor idea is not really infeasible I think (not just 
because the # of file descriptors is "only" doubled, but also because 
most of the time I think you'd only care of per-VM stats).

If you really believe it's not usable for you, you can use two ioctls to 
fill the description and the data respectively (i.e. ioctl(fd, 
KVM_GET_STATS_{DESCRIPTION,VALUES}, pdata) using the same layout as 
below.  If called with NULL argument, the ioctl returns how much data 
they will fill in.

The (always zero) global flags can be replaced by the value returned by 
KVM_CHECK_EXTENSION.

The number of statistics can be obtained by ioctl(fd, 
KVM_GET_STATS_VALUES, NULL), just divide the returned value by 8.

Paolo

>> 4 bytes flags (always zero)
>> 4 bytes number of statistics
>> 4 bytes offset of the first stat description
>> 4 bytes offset of the first stat value
>> stat descriptions:
>>     - 4 bytes for the type (for now always zero: uint64_t)
>>     - 4 bytes for the flags (for now always zero)
>>     - length of name
>>     - name
>> statistics in 64-bit format

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
