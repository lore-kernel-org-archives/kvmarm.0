Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68918C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Mar 2022 17:55:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3C2249F4E;
	Wed, 23 Mar 2022 13:55:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tS2YK5yVidu2; Wed, 23 Mar 2022 13:55:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A16DC49F28;
	Wed, 23 Mar 2022 13:55:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0BED49F28
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 13:55:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vsZdFIdBUub1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Mar 2022 13:55:15 -0400 (EDT)
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com
 [209.85.166.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A7D6149EDE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 13:55:15 -0400 (EDT)
Received: by mail-io1-f51.google.com with SMTP id b16so2633598ioz.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Mar 2022 10:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=PqjJXkRPd2m4fHW7zLlzzJ1D2JbPgS4DO8KeESR34/E=;
 b=kZu2MlxKm4TNZBvgOghSAFo5NR+ctEUYlJYRRkIiuzmM1ykFamILWWhzDO8EMecPc5
 6xqgOn/gtlYLunFPctAB5ciFAEBoydz51eJoeCrf4JgSA2IQsHs69Eg2r8HDQKX5JRd2
 dkkOpKB8CsPeJKN2OpskZlknijt9Ks0Rai/VLmPJN1QXbDspVqFwqJ12VvyU7ud1NnEa
 FZU/oyiEvjEKCG8GCoUNu48GDPeHdXrtRgyeSojd5KcqMrSPbYbn0f0zcigRH3CVSJhG
 O9cC8Gc99HbfDjaRM/SYGn352eUwoVqcC9hPyJ/TAHzQUj22374hoTMB4lxoEB02y+DF
 fPUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=PqjJXkRPd2m4fHW7zLlzzJ1D2JbPgS4DO8KeESR34/E=;
 b=2SMDQLAgVv56Nb/XYKlLlQAmdKkOWSUijPLwxPoGX1nkqnEuN7nzfTkk3IEEtYeAPH
 lneLXqMq/QLH+pMrD84rSpLkjP8nIwe8olKTqlvUzIjqbnr7USsNNk4MEtQtw6PS0il5
 v8wjROjPHp+L9WLdVmBH5+EoEGr5xbQ+H0bLjlyScsgbUjES4/uNE0y4G1ss6H4Tvl3E
 yCoxqH2lscr2V0d2jiFq+bxzYcS4eFx142ogM7wCDlyq/VE6fzgBT4JUvdyCuYq53HFV
 rZPzGLnnCJt2kozJPSDBZxvsA/mhKx1Dsb9d8fDNiKOBSg8oB6jCUhmmKoyTZdO0HWQ4
 tDug==
X-Gm-Message-State: AOAM5339gslyHdXO0dldjILAdqeCxOgt+5FUltwIar4v+Y4xpJ6UrWJg
 yWwFCgaqEx1ncE6EVdvumi/tJA==
X-Google-Smtp-Source: ABdhPJwR2B0E+l4rro6BffINpb+kaE4XruvntOQYHgHUtjRPfYY26xFlWw65UnkzQlX4TCJMWBFoeA==
X-Received: by 2002:a05:6638:218f:b0:321:3fa6:79b8 with SMTP id
 s15-20020a056638218f00b003213fa679b8mr632693jaj.206.1648058114784; 
 Wed, 23 Mar 2022 10:55:14 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 f4-20020a92b504000000b002c21ef70a81sm357051ile.7.2022.03.23.10.55.13
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 23 Mar 2022 10:55:14 -0700 (PDT)
Date: Wed, 23 Mar 2022 17:55:10 +0000
From: Oliver Upton <oupton@google.com>
To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 19/22] KVM: arm64: Support SDEI ioctl commands on vCPU
Message-ID: <Yjte/g4yG+gw7vnt@google.com>
References: <20220322080710.51727-1-gshan@redhat.com>
 <20220322080710.51727-20-gshan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20220322080710.51727-20-gshan@redhat.com>
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

On Tue, Mar 22, 2022 at 04:07:07PM +0800, Gavin Shan wrote:
> This supports ioctl commands on vCPU to manage the various object.
> It's primarily used by VMM to accomplish migration. The ioctl
> commands introduced by this are highlighted as below:
> 
>    * KVM_SDEI_CMD_GET_VCPU_EVENT_COUNT
>      Return the total count of vCPU events, which have been queued
>      on the target vCPU.
> 
>    * KVM_SDEI_CMD_GET_VCPU_EVENT
>    * KVM_SDEI_CMD_SET_VCPU_EVENT
>      Get or set vCPU events.
> 
>    * KVM_SDEI_CMD_GET_VCPU_STATE
>    * KVM_SDEI_CMD_SET_VCPU_STATE
>      Get or set vCPU state.

All of this GET/SET stuff can probably be added to KVM_{GET,SET}_ONE_REG
immediately. Just introduce new registers any time a new event comes
along. The only event we have at the end of this series is the
software-signaled event, with async PF coming later right?

Some special consideration is likely necessary to avoid adding a
register for every u64 chunk of data. I don't think we need to afford
userspace any illusion of granularity with these, and can probably lump
it all under one giant pseudoregister.

>    * KVM_SDEI_CMD_INJECT_EVENT
>      Inject SDEI event.

What events are we going to allow userspace to inject? IIUC, the
software-signaled event is an IPI and really under the control of the
guest. Async PF is entriely under KVM control.

I do agree that having some form of event injection would be great. VM
providers have found it useful to allow users to NMI their VMs when they
get wedged. I just believe that userspace should not be able to trigger
events that have a defined meaning and are under full KVM ownership.

IMO, unless the async PF changes need to go out to userspace, you could
probably skip event injection for now and only worry about SDEI within a
VM.

--
Thanks,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
