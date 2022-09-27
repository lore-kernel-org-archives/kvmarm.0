Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8301C07E9D
	for <kvmarm@archiver.kernel.org>; Tue, 27 Sep 2022 18:21:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 244D94B6B6;
	Tue, 27 Sep 2022 14:21:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id A9LwSGxb3xve; Tue, 27 Sep 2022 14:21:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B692F4B4D7;
	Tue, 27 Sep 2022 14:21:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB5BD4B2B7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 14:21:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nThGE5yP5Qcq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Sep 2022 14:21:08 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D70514B210
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 14:21:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1664302868;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=QY/wexCISEH5Yn9ulasiSSxdGASp9NhnFDcBt09AGSE=;
 b=BJM8kT88CdaVVLTl/F0XZwB3MQnBkL3bc7yu7J8tRHxbYGuuBX6A6E+b5xHQ/X0wDzqXfp
 KGBbNNvzr+FZkod/62h5mfUDiS7z+mNxHwTIwU0cAdTnwXc+F7pvxfAVewIstp5rpcfklE
 Z8INcbYmoOKWhhJh0a8zgLFm2RBQyWs=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-623-WvRwxiPmPlmAZ46P2JmRxg-1; Tue, 27 Sep 2022 14:21:05 -0400
X-MC-Unique: WvRwxiPmPlmAZ46P2JmRxg-1
Received: by mail-qv1-f71.google.com with SMTP id
 mo5-20020a056214330500b004ad711537a6so6365704qvb.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Sep 2022 11:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
 bh=QY/wexCISEH5Yn9ulasiSSxdGASp9NhnFDcBt09AGSE=;
 b=5B74htnbqXMVX0hDElLUBuChSeOIsB+ghXcMosEtuy8JSKZAdEx2m5GksO7axhqmXx
 x/rTRfkRngb89pXGdSe2BcNXedjHVw82p90aJ8kYGDHlF7FQvv/Z1whPmckVKduZK5n9
 NPHnFeNj4Sn8YfSRzx8gnD9VhN+w28mvdqP9/p+GBjcgzUlBLByAjvh/Yx7zR+p/nlRS
 Xx1jTe97g3XJ4wKI0W8gJo30gLsKWOspraAQ80oesgHsVsiRxg7j9RVcjYaCigUtCj7X
 CGIJQ1SiWcWDfOAj/QxIuFP2NKKnJ6XIYKWuZnGw0hvb8KGGrCFrNkwpU154FXlNFSH9
 BLbw==
X-Gm-Message-State: ACrzQf2TvnsUQL2L325j1HPlGtBis83F5rbI9mwtmm5kAfD5Aje3KLjC
 LiDJuUbbWxUhtm1rJTxX5SniGmLdwqBS+GQcaSJwGQwL7qQcPx1nyc+htZUqVfN57ZZQlk2aZ3T
 BSB5ap/dLQseAQYGMdiOoSTZF
X-Received: by 2002:a05:620a:1929:b0:6ce:f8b0:6de0 with SMTP id
 bj41-20020a05620a192900b006cef8b06de0mr19149810qkb.489.1664302864489; 
 Tue, 27 Sep 2022 11:21:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6tmXzpi6e6VsMU3bm+k4T40OUsVM/7nTV5fmstSLxyFluQ1CU5YAxtcJF6kpYrDafr4b9odw==
X-Received: by 2002:a05:620a:1929:b0:6ce:f8b0:6de0 with SMTP id
 bj41-20020a05620a192900b006cef8b06de0mr19149790qkb.489.1664302864293; 
 Tue, 27 Sep 2022 11:21:04 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca.
 [70.31.27.79]) by smtp.gmail.com with ESMTPSA id
 a2-20020ac81082000000b0035d1f846b91sm1214262qtj.64.2022.09.27.11.21.02
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Tue, 27 Sep 2022 11:21:03 -0700 (PDT)
Date: Tue, 27 Sep 2022 14:21:00 -0400
From: Peter Xu <peterx@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory tracking
Message-ID: <YzM/DFV1TgtyRfCA@x1n>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-4-gshan@redhat.com> <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org>
MIME-Version: 1.0
In-Reply-To: <86sfkc7mg8.wl-maz@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kvm@vger.kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
 will@kernel.org, shan.gavin@gmail.com, bgardon@google.com, dmatlack@google.com,
 pbonzini@redhat.com, zhenyzha@redhat.com, shuah@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

On Tue, Sep 27, 2022 at 01:32:07PM -0400, Marc Zyngier wrote:
> On Tue, 27 Sep 2022 12:02:52 -0400,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Tue, Sep 27, 2022 at 08:54:36AM +0800, Gavin Shan wrote:
> > > Enable ring-based dirty memory tracking on arm64 by selecting
> > > CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL and providing the ring buffer's
> > > physical page offset (KVM_DIRTY_LOG_PAGE_OFFSET).
> > > 
> > > Signed-off-by: Gavin Shan <gshan@redhat.com>
> > 
> > Gavin,
> > 
> > Any decision made on how to tackle with the GIC status dirty bits?
> 
> Which dirty bits? Are you talking of the per-RD pending bits?

Gavin found that some dirty pfn path may not have vcpu context for aarch64
offlist.

Borrowing Gavin's trace dump:

  el0t_64_sync
  el0t_64_sync_handler
  el0_svc
  do_el0_svc
  __arm64_sys_ioctl
  kvm_device_ioctl
  vgic_its_set_attr
  vgic_its_save_tables_v0
  kvm_write_guest
  __kvm_write_guest_page
  mark_page_dirty_in_slot

With current code it'll trigger the warning in mark_page_dirty_in_slot.

An userspace approach is doable by setting these pages as always dirty in
userspace (QEMU), but even if so IIUC we'll need to drop the warning
message in mark_page_dirty_in_slot() then we take no-vcpu dirty as no-op
and expected.

I'll leave the details to Gavin.

Thanks,

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
