Return-Path: <SRS0=saMt=KH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB0CC433ED
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:06:47 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E09AA6198B
	for <kvmarm@archiver.kernel.org>; Wed, 12 May 2021 16:06:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E09AA6198B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33F5B4B530;
	Wed, 12 May 2021 12:06:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iHrcRVpXo8O7; Wed, 12 May 2021 12:06:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E73B4B552;
	Wed, 12 May 2021 12:06:45 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C9CB4B480
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:06:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wRqSSgKHy8hZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 May 2021 12:06:42 -0400 (EDT)
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com
 [209.85.215.174])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C3B2D4B552
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 12:06:42 -0400 (EDT)
Received: by mail-pg1-f174.google.com with SMTP id 33so191599pgo.5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 May 2021 09:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:content-transfer-encoding:in-reply-to;
 bh=dgHbOLOeSj5WKbYYrBAPLjp+f/dwtBzWBZ4797F6XUY=;
 b=e0Y+6aQ4yaGK7mLERwh7bRnbUGpEsba/vWgxviu4hiqJ2TDknS0YbLE/PCHvBHKLdp
 r7rXRSv4M5zcTlW3mVyZHXRvuF8v9zhy76xYEGfbeNlCjMXQ7kMxFz7OsOahEo+azl/u
 DXDUdie3Vre2iSrbE8UIxNHonczaH1OfjmNvZ6u9h4z9/I7PUgQ6cg/5Y0PuCHO9Qq24
 6h+dkMBG9aJ+JlrmMDRWglC1RCfXZmpUuzcxOT9IqunqkiEJcaD7gr5ExafEkb4c6taK
 YGKSlxUPquyGLHjlSDd+yGfPUEEgITzLRCtLOwET6Wjdb4lc+mq2rfcHhh6XpbbJre3U
 7I+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:content-transfer-encoding
 :in-reply-to;
 bh=dgHbOLOeSj5WKbYYrBAPLjp+f/dwtBzWBZ4797F6XUY=;
 b=sPQTJXVCYv/H5HUr1l42ldxV0c2AXNzUU3+zJCk7luLB5zvL5xA281ejFDlIi6vy34
 PMpe+x3joNu4RE8MQLTm2oHazgw0tAF2aMnxeIBu10maIggibfOATBknyUHOC3Zv+xbH
 GZRGIItIRVMh923u+A2OsIVUEmtqNwEiqQUKoxo88ub38lgfGd+D2gm8rvdWcSSxfiAA
 k+jH1o4fL1OIJ+1lEpqeKD9Xb2FsB54ZlsC1UaFN2Z9YOcJMPnNhhTw6wPjTtvdJulcf
 nQfnzVvai9sDqjiI9fKTXDEAPEMLFNIyOdbP4d1YXCAoETEG4rWYhV3bK5ixtDpAmB1k
 bMug==
X-Gm-Message-State: AOAM532yymZ2Xa4/u16ui/mBR8qG2gGPDEm7Xwl/pHTL8mqrjf8n96L7
 qpWngXtcmDOfngXsg/ITK2HaWg==
X-Google-Smtp-Source: ABdhPJwCnyutMSxtRMlZCImn/MhoJ/z1aUOeS5rTLjqqupr6g4dPYtzV1nLinn5hNQDtN8Brl2rMBA==
X-Received: by 2002:a62:3003:0:b029:28e:74d9:1e16 with SMTP id
 w3-20020a6230030000b029028e74d91e16mr37368927pfw.21.1620835601750; 
 Wed, 12 May 2021 09:06:41 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com.
 [34.83.12.150])
 by smtp.gmail.com with ESMTPSA id b13sm240823pfl.140.2021.05.12.09.06.41
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 12 May 2021 09:06:41 -0700 (PDT)
Date: Wed, 12 May 2021 09:06:37 -0700
From: Ricardo Koller <ricarkol@google.com>
To: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH v2 4/5] KVM: selftests: Add exception handling support
 for aarch64
Message-ID: <YJv9DYIvqRW24P5C@google.com>
References: <20210430232408.2707420-5-ricarkol@google.com>
 <87a6pcumyg.wl-maz@kernel.org> <YJBLFVoRmsehRJ1N@google.com>
 <20915a2f-d07c-2e61-3cce-ff385e98e796@redhat.com>
 <YJRADhU4CcTE7bdm@google.com>
 <8a99d57b-0513-557c-79e0-98084799812f@redhat.com>
 <YJuDYZbqe8V47YCJ@google.com>
 <4e83daa3-3166-eeed-840c-39be71b1124d@redhat.com>
 <348b978aad60db6af7ba9c9ce51bbd87@kernel.org>
 <628dca08-4108-8be1-9bea-8c388f28401e@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <628dca08-4108-8be1-9bea-8c388f28401e@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, pbonzini@redhat.com,
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
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Wed, May 12, 2021 at 10:52:09AM +0200, Auger Eric wrote:
> Hi,
> =

> On 5/12/21 10:33 AM, Marc Zyngier wrote:
> > On 2021-05-12 09:19, Auger Eric wrote:
> >> Hi Ricardo,
> >>
> >> On 5/12/21 9:27 AM, Ricardo Koller wrote:
> >>> On Fri, May 07, 2021 at 04:08:07PM +0200, Auger Eric wrote:
> >>>> Hi Ricardo,
> >>>>
> >>>> On 5/6/21 9:14 PM, Ricardo Koller wrote:
> >>>>> On Thu, May 06, 2021 at 02:30:17PM +0200, Auger Eric wrote:
> >>>>>> Hi Ricardo,
> >>>>>>
> >>>>>
> >>>>> Hi Eric,
> >>>>>
> >>>>> Thank you very much for the test.
> >>>>>
> >>>>>> On 5/3/21 9:12 PM, Ricardo Koller wrote:
> >>>>>>> On Mon, May 03, 2021 at 11:32:39AM +0100, Marc Zyngier wrote:
> >>>>>>>> On Sat, 01 May 2021 00:24:06 +0100,
> >>>>>>>> Ricardo Koller <ricarkol@google.com> wrote:
> >>>>>>>>>
> >>>>>>>>> Add the infrastructure needed to enable exception handling in
> >>>>>>>>> aarch64
> >>>>>>>>> selftests. The exception handling defaults to an
> >>>>>>>>> unhandled-exception
> >>>>>>>>> handler which aborts the test, just like x86. These handlers
> >>>>>>>>> can be
> >>>>>>>>> overridden by calling vm_install_vector_handler(vector) or
> >>>>>>>>> vm_install_exception_handler(vector, ec). The unhandled excepti=
on
> >>>>>>>>> reporting from the guest is done using the ucall type
> >>>>>>>>> introduced in a
> >>>>>>>>> previous commit, UCALL_UNHANDLED.
> >>>>>>>>>
> >>>>>>>>> The exception handling code is heavily inspired on kvm-unit-tes=
ts.
> >>>>>>
> >>>>>> running the test on 5.12 I get
> >>>>>>
> >>>
> >>> Hi Eric,
> >>>
> >>> I'm able to reproduce the failure you are seeing on 5.6, specifically
> >>> with kernels older than this commit:
> >>>
> >>> =A0 4942dc6638b0 KVM: arm64: Write arch.mdcr_el2 changes since last
> >>> vcpu_load on VHE
> >>>
> >>> but not yet on v5.12. Could you share the commit of the kernel you are
> >>> testing, please?
> >>
> >> my host is a 5.12 kernel (8404c9fbc84b)
> > =

> > Time to compare notes then. What HW are you using? Running VHE or not?
> VHE yes. Cavium Sabre system.
> =


On my side. VHE (v5.12) on both QEMU (5.2.0 cpu=3Dmax) and Ampere Altra.

> Thanks
> =

> Eric
> > =

> > Thanks,
> > =

> > =A0=A0=A0=A0=A0=A0=A0 M.
> =

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
