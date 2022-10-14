Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B61BC43217
	for <kvmarm@archiver.kernel.org>; Fri, 14 Oct 2022 16:55:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 08098413E2;
	Fri, 14 Oct 2022 12:55:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Km5uYw-D67Gx; Fri, 14 Oct 2022 12:55:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABA6D4B105;
	Fri, 14 Oct 2022 12:55:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 595024B105
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 12:55:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LuWhz1mlY5xr for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Oct 2022 12:55:41 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4CE6C413E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 12:55:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665766540;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=inMtT+hoYNUBiTHjQTMih3j26iePj23of4ePHLqNIX8=;
 b=IImivX0zdH+ls+KlQa5IKOvLvxPaPsP6RxpKFDqC9mBIT1toYqpxEkX6tbpk1jz0mRn4CJ
 IjvEXbIevMfUzWYh/+k7zoWJVQLNH2cgmw5ZZ9jZ8m29Fo8nC3RHOavdz3aqAg6+yUEPtG
 7mmp49K/2kELk1JgUZL1iFuclhwj/xs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-208-29V2rNBGOFyUHQW7F6PCjg-1; Fri, 14 Oct 2022 12:55:39 -0400
X-MC-Unique: 29V2rNBGOFyUHQW7F6PCjg-1
Received: by mail-qk1-f197.google.com with SMTP id
 u6-20020a05620a430600b006e47fa02576so3915208qko.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Oct 2022 09:55:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=inMtT+hoYNUBiTHjQTMih3j26iePj23of4ePHLqNIX8=;
 b=cwAPMhamba0KXNe7ISskZTSrMJCjQ8V2I6v6eau72il4qxZQZfD7KWKGsdwTNl3xSr
 prmyhfFsZ4PcJtNKebEegWJukgPSsOoXjtr+9RQnC0syb/4F979Wuiqu8vF+LYGnHek/
 WVPQSmnUYIkS4MRdT/XKpcZuF8H/XgYbk4aHMzbU68e1/kJC7mkGvFgBWJpqOBXwBsl0
 4hBfIIR7SZqxMNwiRxGtIqXMFhVwEcz1z44sWApxjvlQcgsD8vbVOC2MnDLZCt/QSt92
 vCbFeiBjZ7TDVxnAaHPOfdXhjH1s0sVztgLtAhs3l05TWQan3jQ9mWR5z4HJwXNEu/wM
 Hc8w==
X-Gm-Message-State: ACrzQf0n/aPSm/ydP8xXAmnsySeCnQCEPHQBf1Q+8JDsPAMMR35+ImRw
 X8U9I7Djw6GTxcFFWJgq/oRP2aeRVm0NGxkbDiPpK2ktmwA7QNLopQ48k5YqJamaBoCMMnVoEpv
 e6c2KcsMeJl3WE9cLBN8YIeyD
X-Received: by 2002:ac8:58c2:0:b0:398:f5c4:9bed with SMTP id
 u2-20020ac858c2000000b00398f5c49bedmr4982989qta.367.1665766538534; 
 Fri, 14 Oct 2022 09:55:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7RWlwjY7fwX0sXAm2JU/iQpzMQf5jfJhmR78proXq2TEBVxm0GapOTir5grGpSntiVMzL4Gw==
X-Received: by 2002:ac8:58c2:0:b0:398:f5c4:9bed with SMTP id
 u2-20020ac858c2000000b00398f5c49bedmr4982978qta.367.1665766538317; 
 Fri, 14 Oct 2022 09:55:38 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 d22-20020a376816000000b006ce0733caebsm2726739qkc.14.2022.10.14.09.55.36
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 14 Oct 2022 09:55:37 -0700 (PDT)
Date: Fri, 14 Oct 2022 12:55:35 -0400
From: Peter Xu <peterx@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0mUh5dEErRVtfjl@x1n>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com> <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n> <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local> <Y0SxnoT5u7+1TCT+@google.com>
 <Y0S2zY4G7jBxVgpu@xz-m1.local> <Y0TDCxfVVme8uPGU@google.com>
MIME-Version: 1.0
In-Reply-To: <Y0TDCxfVVme8uPGU@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 dmatlack@google.com, will@kernel.org, shan.gavin@gmail.com, bgardon@google.com,
 kvmarm@lists.linux.dev, pbonzini@redhat.com, zhenyzha@redhat.com,
 shuah@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Tue, Oct 11, 2022 at 01:12:43AM +0000, Oliver Upton wrote:
> The VMM must know something about the architecture it is running on, as
> it calls KVM_DEV_ARM_ITS_SAVE_TABLES after all...

IIUC this is still a kernel impl detail to flush data into guest pages
within this ioctl, or am I wrong?

For example, I'm assuming it's safe to change KVM_DEV_ARM_ITS_SAVE_TABLES
impl one day to not flush data to guest memories, then the kernel should
also disable the ALLOW_BITMAP cap in the same patch, so that any old qemu
binary that supports arm64 dirty ring will naturally skip all the bitmap
ops and becoming the same as what it does with x86 when running on that new
kernel.  With implicit approach suggested, we need to modify QEMU.

Changing impl of KVM_DEV_ARM_ITS_SAVE_TABLES is probably not a good
example.. but just want to show what I meant.  Fundamentally it sounds
cleaner if it's the kernel that tells the user "okay you collected the
ring, but that's not enough; you need to collect the bitmap too", rather
than assuming the user app will always know what kvm did in details.  No
strong opinion though, as I could also have misunderstood how arm works.

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
