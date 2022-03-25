Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 235C6C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 25 Mar 2022 08:38:03 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DB1449F0A;
	Fri, 25 Mar 2022 04:38:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id opmdvCgIQBaf; Fri, 25 Mar 2022 04:38:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DD344B0BF;
	Fri, 25 Mar 2022 04:38:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A4434B0CE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 04:38:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h-aadGxBxB-R for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Mar 2022 04:38:00 -0400 (EDT)
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com
 [209.85.166.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6A9EC4B099
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 04:38:00 -0400 (EDT)
Received: by mail-il1-f173.google.com with SMTP id e18so4765535ilr.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Mar 2022 01:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=9k7Y8WevncKwpBhN8GfDJPtpTXD3hrhwGt8wNGgKE88=;
 b=kJla5xL5682VRhITm7mYpJSv9xA9f20EYy0FOb4lmRJ066bsONolddlq/nDZsS4qWo
 2Bt9vcCBjbPhDlVY0oyvJavLRj9bI1ArzI5Rm+Z7ke8cj87XhsmPgWO23LLnzZ/WMUc8
 q9f13beidyvk7D71B9sc4ctKwiUEKWYlJFqs91ZM4KLOOsIRp7RNwr0zd1uqU7PqmHbe
 VVoRwef+mProrNYGLhVLAbi23Fmzuer5EAFDs0I69UE0jRJ8cb1yBZaYhZ+czqTCKKM+
 /cxjfaWlopTIwU6JKrOi7NKANp5xsx8PmlbgrnKVXf0jvLPq3IGDH7RtEntiWpSIUgBb
 G7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=9k7Y8WevncKwpBhN8GfDJPtpTXD3hrhwGt8wNGgKE88=;
 b=rHsFlDsu4V1Nd7E82baurd5v1CM9+HhyO3Bm7YDhV2mOCxqB3AtlrcZbThX3V2BFRs
 TqGrUy7SPdk2cj2sU7EIfNkOty0kDeABDRaKqgwKgm04b4Y66ZMMAqqGlTfyP/8PLbCe
 F+Tbk2Ml5qPp/3QAb7dIzvL5YhjdoYXHV1niw5OZKFvqirq0njELqiPbrAtnpolETvk/
 5Zy3sVuoLQE6MTL4Lc0GXRdD/ohxf5vZf3BOi2mBEeXBiiddPKqHMt3li0ynNpwe/Sj/
 F5TWrS/cgxzjnwAtSTUiC82OfWdeNEU2zIEDF+3tgYEbQX3l1PZJdLtYx3cR+HcsQBuk
 BXtA==
X-Gm-Message-State: AOAM5319HrJOZ6Y1cZVRmzsaWMjqkkejo2+iMDKeETOc5ZahqFGqjZqr
 AcAs6hTjNWLEgA/vVd1rb3/QZA==
X-Google-Smtp-Source: ABdhPJyJC/YiQb6vlBS9ZFN2J20kwUvAt30H61gUwhYDFICPDSxDuwwh3f3X9GJ3e+aSc/EZEZufQQ==
X-Received: by 2002:a05:6e02:2162:b0:2c8:47b8:d3e1 with SMTP id
 s2-20020a056e02216200b002c847b8d3e1mr4875222ilv.59.1648197479512; 
 Fri, 25 Mar 2022 01:37:59 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 v3-20020a5d9483000000b00640d3d4acabsm2593820ioj.44.2022.03.25.01.37.58
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Fri, 25 Mar 2022 01:37:58 -0700 (PDT)
Date: Fri, 25 Mar 2022 08:37:55 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 19/22] KVM: arm64: Support SDEI ioctl commands on vCPU
Message-ID: <Yj1/Y5ql0d0h39rX@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-20-gshan@redhat.com>
 <Yjte/g4yG+gw7vnt@google.com>
 <949146db-d467-4949-9e82-94f803c3b166@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <949146db-d467-4949-9e82-94f803c3b166@redhat.com>
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On Fri, Mar 25, 2022 at 03:59:50PM +0800, Gavin Shan wrote:
> Hi Oliver,
> 
> On 3/24/22 1:55 AM, Oliver Upton wrote:
> > On Tue, Mar 22, 2022 at 04:07:07PM +0800, Gavin Shan wrote:
> > > This supports ioctl commands on vCPU to manage the various object.
> > > It's primarily used by VMM to accomplish migration. The ioctl
> > > commands introduced by this are highlighted as below:
> > > 
> > >     * KVM_SDEI_CMD_GET_VCPU_EVENT_COUNT
> > >       Return the total count of vCPU events, which have been queued
> > >       on the target vCPU.
> > > 
> > >     * KVM_SDEI_CMD_GET_VCPU_EVENT
> > >     * KVM_SDEI_CMD_SET_VCPU_EVENT
> > >       Get or set vCPU events.
> > > 
> > >     * KVM_SDEI_CMD_GET_VCPU_STATE
> > >     * KVM_SDEI_CMD_SET_VCPU_STATE
> > >       Get or set vCPU state.
> > 
> > All of this GET/SET stuff can probably be added to KVM_{GET,SET}_ONE_REG
> > immediately. Just introduce new registers any time a new event comes
> > along. The only event we have at the end of this series is the
> > software-signaled event, with async PF coming later right?
> > 
> > Some special consideration is likely necessary to avoid adding a
> > register for every u64 chunk of data. I don't think we need to afford
> > userspace any illusion of granularity with these, and can probably lump
> > it all under one giant pseudoregister.
> > 
> 
> Yes, KVM_{GET,SET}_ONE_REG is the ideal interface for migration. You're
> correct we're only concerned by software signaled event and the one for
> Async PF.
> 
> I didn't look into Raghavendra's series deeply. Actually, a lump of
> registers can be avoid after 2048 byte size is specified in its
> encoding. I think 2048 bytes are enough for now since there are
> only two supported events.

When I had said 'one giant pseudoregister' I actually meant 'one
pseudoregister per event', not all of SDEI into a single
structure. Since most of this is in flux now, it is hard to point
out what/how we should migrate from conversation alone.

And on the topic of Raghavendra's series, I do not believe it is
required anymore here w/ the removal of shared events, which I'm
strongly in favor of.

Let's delve deeper into migration on the next series :)

> In the future, we probably have varied number of SDEI events to
> be migrated. In that case, we need to add a new bit to the encoding
> of the pseudo system register, so that VMM (QEMU) can support
> variable sized system register and keep reading and writing on
> these registers on migration:
> 
>     PSEUDO_SDEI_ADDR: 64-bits in width
>     PSEUDO_SDEI_DATA: has varied size
> 
> PSEUDO_SDEI_ADDR is used to (1) Indicate the size of PSEUDO_SDEI_DATA
> (2) The information to be read/written, for example the (shared/private)
> registered events on VM and vCPU, VCPU state.
> 
> PSEUDO_SDEI_DATA is used to (1) Retrieved information or that to be
> written. (2) Flags to indicate current block of information is the
> last one or not.

I don't think we have sufficient encoding space in the register ID
to allow for arbitrary length registers. Any new registers for SDEI will
need to fit into one of the predefined sizes. Note that we've already
conditioned userspace to handle registers this way and anything else is
an ABI change.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
