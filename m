Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D02DC43334
	for <kvmarm@archiver.kernel.org>; Tue,  5 Jul 2022 07:44:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC57C4BCBC;
	Tue,  5 Jul 2022 03:44:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mmC8E+ABaLBF; Tue,  5 Jul 2022 03:44:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6F564BADA;
	Tue,  5 Jul 2022 03:44:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0D704BADA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2022 03:44:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wQuyXNzqO89D for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jul 2022 03:44:29 -0400 (EDT)
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com
 [209.85.218.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 370224BAC9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jul 2022 03:44:29 -0400 (EDT)
Received: by mail-ej1-f45.google.com with SMTP id h23so20099144ejj.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 05 Jul 2022 00:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=sender:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=p4WrMxeyT1HLi3JYPDHBaEUMJazd4JiPotMxjccrcOI=;
 b=CK+VMuXOPY60wZIVnAZQ7xwsWPl4STCGWQlj/Y18ImlheH0kMnUdhDdWi2v4ywwXmq
 yjHK+NcgnPIhVXFoSX6iSCXcS3A4e/QPb9T0sZ7zoiyIL3pgL9bYaDlU6lN/1OqtNlOv
 0dWLVaELMs9oq5gi5ydvR8KrBxRkcYTQKbOlwCtoWK/9EJ5LutESLfPxwzAUbEDK4/g1
 khxj4shhIg+dAlVTSI3bANq6Q1I9HD/oLluGmKLyk18HiHYla4CkrwemkOOTUjD5qfIE
 jq97luvgK97KDecXPKhtpjCDAt5X+keNa39ncJyV5CgHNh5c40L3XIs6VxGBo7gfEHeA
 eWxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
 :subject:content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding;
 bh=p4WrMxeyT1HLi3JYPDHBaEUMJazd4JiPotMxjccrcOI=;
 b=7NT4LofoPg4hBqbSj4svmQmqB/eHJw/83P7oFBOtRapK8nQ4oCzhi2UjUqlz+eSuyi
 tU8fdz+Jlb7fjvFUnJ/866pFF4eIJ2Gy5kJEJPiKSifAlb2ifTeg3nCp1BDghT2atDtz
 gCJ7FzHZZ+l8FpEVSGd65vK3RCES9K8J6o5kZNj9HVFmzD9rlxTbpxdclX0Mz/buPEQ5
 XNof+kTvLVv8oE/VIUDdMR7I29xvkw1GL/qUfikHOl9O7Wl/EtrVD3lZMWgQJk6+g5T6
 oNMOXxvQOd0yjjiWIk0+35+0aikRNML9oU7MM8tzDP1GBwXtpYyyyFzI73GjspVmclyZ
 UWIg==
X-Gm-Message-State: AJIora/iWdHybD1wps6NsWycrS5kD5YGy2yrPhOH0PB031oKCON3LKn+
 etMyHkWAIDIFddeCPfRGPlg=
X-Google-Smtp-Source: AGRyM1ucemoQZ09Gw0/I3mQiuc+mMrI6EyC3S8EzKzn1mq2Vr1UVjIxLl4dhAvYlXIFb38KeVU+UgA==
X-Received: by 2002:a17:907:9710:b0:726:bdf6:edee with SMTP id
 jg16-20020a170907971000b00726bdf6edeemr32212369ejc.48.1657007068117; 
 Tue, 05 Jul 2022 00:44:28 -0700 (PDT)
Received: from [192.168.89.248] (93-33-54-161.ip43.fastwebnet.it.
 [93.33.54.161]) by smtp.googlemail.com with ESMTPSA id
 d1-20020a056402516100b0043a09f6fc24sm6149293ede.47.2022.07.05.00.44.25
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Tue, 05 Jul 2022 00:44:27 -0700 (PDT)
Message-ID: <f719c5fb-3e41-38ac-1b16-fcb603e4911f@redhat.com>
Date: Tue, 5 Jul 2022 09:44:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v7 00/22] Support SDEI Virtualization
Content-Language: en-US
To: Marc Zyngier <maz@kernel.org>, Gavin Shan <gshan@redhat.com>
References: <20220527080253.1562538-1-gshan@redhat.com>
 <6bdb9280-3530-dc1f-d33e-5bc1c5ac927b@redhat.com>
 <87iloq2oke.wl-maz@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87iloq2oke.wl-maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 shijie@amperemail.onmicrosoft.com, linux-kernel@vger.kernel.org,
 eauger@redhat.com, shan.gavin@gmail.com, Jonathan.Cameron@huawei.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
 Peter Feiner <pfeiner@google.com>
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

On 6/24/22 15:12, Marc Zyngier wrote:
> - as far as I know, the core Linux/arm64 maintainers have no plan to
>    support APF. Without it, this is a pointless exercise. And even with
>    it, this introduces a Linux specific behaviour in an otherwise
>    architectural hypervisor (something I'm quite keen on avoiding)

Regarding non-architectural behavior, isn't that the same already for 
PTP?  I understand that the PTP hypercall is a much smaller 
implementation than SDEI+APF, but it goes to show that KVM is already 
not "architectural".

There are other cases where paravirtualized solutions can be useful. 
PTP is one but there are more where KVM/ARM does not have a solution 
yet, for example lock holder preemption.  Unless ARM (the company) has a 
way to receive input from developers and standardize the interface, 
similar to the RISC-V SIGs, vendor-specific hypercalls are a sad fact of 
life.  It just happened that until now KVM/ARM hasn't seen much use in 
some cases (such as desktop virtualization) where overcommitted hosts 
are more common.

Async page faults per se are not KVM specific, in fact Linux supported 
them for the IBM s390 hypervisor long before KVM added support.  They 
didn't exist on x86 and ARM, so the developers came up with a new 
hypercall API and for x86 honestly it wasn't great.  For ARM we learnt 
from the mistakes and it seems to me that SDEI is a good match for the 
feature.  If ARM wants to produce a standard interface for APF, whether 
based on SDEI or something else, we're all ears.

Regarding plans of core arm64 maintainers to support async page fault, 
can you provide a pointer to the discussion?  I agree that if there's a 
hard NACK for APF for whatever reason, the whole host-side code is 
pointless (including SDEI virtualization); but I would like to read more 
about it.

> - It gives an incentive to other hypervisor vendors to add random crap
>    to the Linux mm subsystem, which is even worse. At this stage, we
>    might as well go back to the Xen PV days altogether.

	return -EGREGIOUS;

Since you mention hypervisor vendors and there's only one hypervisor in 
Linux, I guess you're not talking about the host mm/ subsystem 
(otherwise yeah, FOLL_NOWAIT is only used by KVM async page faults).

So I suppose you're talking about the guest, and then yeah, it sucks to 
have multiple hypervisors providing the same functionality in different 
ways (or multiple hypervisors providing different subsets of PV 
functionality).  It happens on x86 with Hyper-V and KVM, and to a lesser 
extent Xen and VMware.

But again, KVM/ARM has already crossed that bridge with PTP support, and 
the guest needs exactly zero code in the Linux mm subsystem (both 
generic and arch-specific) to support asynchronous page faults.  There 
are 20 lines of code in do_notify_resume(), and the rest is just SDEI 
gunk.  Again, I would be happy to get a pointer to concrete objections 
from the Linux ARM64 maintainers.  Maybe a different implementation is 
possible, I don't know.

In any case it's absolutely not comparable to Xen PV, and you know it.

> - I haven't seen any of the KVM/arm64 users actually asking for the
>    APF horror, and the cloud vendors I directly asked had no plan to
>    use it, and not using it on their x86 systems either

Please define "horror" in more technical terms.  And since this is the 
second time I'm calling you out on this, I'm also asking you to avoid 
hyperboles and similar rhetorical gimmicks in the future.

That said: Peter, Sean, Google uses or used postcopy extensively on GCE 
(https://dl.acm.org/doi/pdf/10.1145/3296975.3186415).  If it doesn't use 
it on x86, do you have any insights on why?

> - no performance data nor workloads that could help making an informed
>    decision have been disclosed, and the only argument in its favour
>    seems to be "but x86 has it" (hardly a compelling one)

Again this is just false, numbers have been posted 
(https://lwn.net/ml/linux-kernel/20210209050403.103143-1-gshan@redhat.com/ 
was the first result that came up from a quick mailing list search).  If 
they are not enough, please be more specific.

Thanks,

Paolo
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
