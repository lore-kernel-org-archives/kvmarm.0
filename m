Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DF91C433FE
	for <kvmarm@archiver.kernel.org>; Tue, 11 Oct 2022 00:20:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03C984B628;
	Mon, 10 Oct 2022 20:20:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nLoFtthB62BR; Mon, 10 Oct 2022 20:20:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E4B24B293;
	Mon, 10 Oct 2022 20:20:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FE354B1B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 20:20:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c4GoJse3qsD2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Oct 2022 20:20:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B0C849EEF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 20:20:33 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1665447633;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=rVV+6Wph3bAh4tPNroZhezVIi89kwJLdBTdHtGxU0T0=;
 b=X9pd+nfJ4z8HeQCd9NglpvtpnYtifFz9QxbJEQXKtMKC6WEj1WhSOIWmmoIShAv7E6JRfr
 n6phZ346qfzn+T2USCfumHuwkHNAp8fQZmNKI7qDRVf6CGSxNJ7/eulMxTpdHinc0IkCfV
 AifG+d6Mh+xpYs1Mit7Aq41MWgL/pKc=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-644-kj7b4mpPMk6glFcMHdzLdA-1; Mon, 10 Oct 2022 20:20:32 -0400
X-MC-Unique: kj7b4mpPMk6glFcMHdzLdA-1
Received: by mail-qt1-f198.google.com with SMTP id
 gc10-20020a05622a59ca00b003951e095c04so7069463qtb.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Oct 2022 17:20:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=in-reply-to:content-disposition:mime-version:references:message-id
 :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
 :message-id:reply-to;
 bh=rVV+6Wph3bAh4tPNroZhezVIi89kwJLdBTdHtGxU0T0=;
 b=z6gh3a3FslkGWYJe6FCGJqNmScZXo87fYLTNkYsT/QWsah9L+zsGGPP7j5/w+fT46d
 FtFZKMK2038yNs/GF5ZQqfUlopx//vntTH5uBmWfo6bD8TiEqSvnyMtaxgrM+1bVBcei
 L+0S+7s/LCh9pl0ecLVJ81Ovbe7Cn/oy1bzVqCB/usEwS2rVCkMkwUXlJKmU/Yc4beJS
 5QlBdNZqzUAzPqATpcQ971fxNUxMonya57dAXCQyPkqQkzvBT5Fnz3PMif2o1zdD4BE7
 vsXrFFT0wGE3pfNAdi6gvVJChPZ9Lz2KMdFkqarDvYtXMtwpGWeUjvSBYMxQItZgMjCh
 Rakg==
X-Gm-Message-State: ACrzQf2cbBl4nYl+6hQ3rzEHQL5lGK1TTkx8OFwHAdgCav+AjTVTLF6p
 /f3a1HA+hcLlqBacWRncBoGNtin0nZCB/W3Lnq//isDjebjfbXUh9RGdT9rgJQkzb7iTl+rlq3o
 0Qfu0+gSeiRiZv6lBGuBkzCht
X-Received: by 2002:ad4:5c85:0:b0:4b3:cac2:d5c1 with SMTP id
 o5-20020ad45c85000000b004b3cac2d5c1mr13650812qvh.116.1665447632107; 
 Mon, 10 Oct 2022 17:20:32 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4APqlKaeubLmKzZv8PniURDxG3Aan94kqA3Nfb19HmD+OXgHG0Yf2LeCneMPb1rOCBmvdDWg==
X-Received: by 2002:ad4:5c85:0:b0:4b3:cac2:d5c1 with SMTP id
 o5-20020ad45c85000000b004b3cac2d5c1mr13650793qvh.116.1665447631931; 
 Mon, 10 Oct 2022 17:20:31 -0700 (PDT)
Received: from xz-m1.local
 (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
 by smtp.gmail.com with ESMTPSA id
 d12-20020a05620a240c00b006cf8fc6e922sm11430594qkn.119.2022.10.10.17.20.30
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Mon, 10 Oct 2022 17:20:31 -0700 (PDT)
Date: Mon, 10 Oct 2022 20:20:29 -0400
From: Peter Xu <peterx@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
Message-ID: <Y0S2zY4G7jBxVgpu@xz-m1.local>
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com> <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com>
 <Y0A4VaSwllsSrVxT@x1n> <Y0SoX2/E828mbxuf@google.com>
 <Y0SvexjbHN78XVcq@xz-m1.local> <Y0SxnoT5u7+1TCT+@google.com>
MIME-Version: 1.0
In-Reply-To: <Y0SxnoT5u7+1TCT+@google.com>
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

On Mon, Oct 10, 2022 at 11:58:22PM +0000, Oliver Upton wrote:
> I think this further drives the point home -- there's zero need for the
> bitmap with dirty ring on x86, so why even support it? The proposal of
> ALLOW_BITMAP && DIRTY_RING should be arm64-specific. Any other arch that
> needs to dirty memory outside of a vCPU context can opt-in to the
> behavior.

Yeah that sounds working too, but it'll be slightly hackish as then the
user app will need some "#ifdef ARM64" blocks for e.g. sync dirty bitmap.
With the new cap the user app can implement the whole ring with generic
code.

Also more flexible to expose it as generic cap? E.g., one day x86 can
enable this too for whatever reason (even though I don't think so..).

-- 
Peter Xu

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
