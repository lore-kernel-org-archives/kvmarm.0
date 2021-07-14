Return-Path: <SRS0=5+eb=MG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B98C12002
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 20:02:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D12E461260
	for <kvmarm@archiver.kernel.org>; Wed, 14 Jul 2021 20:02:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D12E461260
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4BA6C4B080;
	Wed, 14 Jul 2021 16:02:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YBh8cfEyaBq1; Wed, 14 Jul 2021 16:01:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D12F4A522;
	Wed, 14 Jul 2021 16:01:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C88494A524
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 16:01:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VYtCPXepinzp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Jul 2021 16:01:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E706A404F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 16:01:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1626292916;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=sQM1t+sm3YURTxJOPDtOEB2n2+vo2zYAMj6B34VXxkw=;
 b=hHcoW8opUes7QNHLPpWecezPUYUxpfowYBwNKfJJrnBie+SnvOWMqfzC+1+Kxqp5Pdn0ew
 62p5nnK0Ei+7T7vCRC5OQX/uHM/lGt28Uw0iei9klX9gCkq3rkM7yed8YX3c6JkBROVyuj
 7Pu9rq93OGI0sHbboQy697EwERKcOEA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-zBY2EGE4ODCp9_Ec1F-eqg-1; Wed, 14 Jul 2021 16:01:52 -0400
X-MC-Unique: zBY2EGE4ODCp9_Ec1F-eqg-1
Received: by mail-qk1-f200.google.com with SMTP id
 t144-20020a3746960000b02903ad9c5e94baso2081665qka.16
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Jul 2021 13:01:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sQM1t+sm3YURTxJOPDtOEB2n2+vo2zYAMj6B34VXxkw=;
 b=rTpnrucIfFJeYSH2msiMvpU8sTRmKCVYZ9eSTcnoaOexhO+YAM4LmeAYoXoTjZ4bcb
 OKhkoVJt2CmmNwqq+1bMeVf8bN7VxTmQmKmWPhvcV6AociPIt+FCzixXMlXfrMVtfwMF
 cUxbGPFSr0vhqjT6CQaMd80PfUwKTeJGdvLAFGSlIxgbtH/LmL+TQIoyh80qEQqpVf2Q
 LV2hcYYrYASxKmTDbxU0Y9r/qaMAkdx7mujZoZvnkLtB+03pCI9fr9HHY7iUODYR4YyD
 4QU518t4Q982w+uOhnXPUtE4UD3L8zNPmVnHdAnfRiDaqRSuH0FjHFRa1AdaguTjMcmT
 h7fw==
X-Gm-Message-State: AOAM533Cn8oaUwjG5f4XnYOInKKAqIJx+vu6/Pec8SukItB0WgUSUgjq
 edp/YUwQhCZqVrbJdu81h7QG7AInf8JT6BMnFxHnwTKlak2ellD/OG6Za5xjHOm0YjDSXYbIyg5
 /nSUaNiEuZAmP2/WUHX5U40My
X-Received: by 2002:a05:620a:24c7:: with SMTP id
 m7mr11467459qkn.143.1626292911998; 
 Wed, 14 Jul 2021 13:01:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyk3zeWWq9kFBADIM8pqrA3Tmt8g/FfXldlWPscDEzBqvEiYx2I+tAs3oIgkN/bg/94hw4gdg==
X-Received: by 2002:a05:620a:24c7:: with SMTP id
 m7mr11467440qkn.143.1626292911820; 
 Wed, 14 Jul 2021 13:01:51 -0700 (PDT)
Received: from gator ([140.82.166.162])
 by smtp.gmail.com with ESMTPSA id p187sm1505865qkd.101.2021.07.14.13.01.50
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Wed, 14 Jul 2021 13:01:51 -0700 (PDT)
Date: Wed, 14 Jul 2021 22:01:48 +0200
From: Andrew Jones <drjones@redhat.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH v2 09/13] KVM: arm64: Add trap handlers for protected VMs
Message-ID: <20210714200148.vjujrwsn2qsfd6kd@gator>
References: <20210615133950.693489-1-tabba@google.com>
 <20210615133950.693489-10-tabba@google.com>
 <20210701140821.GI9757@willie-the-truck>
MIME-Version: 1.0
In-Reply-To: <20210701140821.GI9757@willie-the-truck>
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=drjones@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Disposition: inline
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com,
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

On Thu, Jul 01, 2021 at 03:08:22PM +0100, Will Deacon wrote:
> On Tue, Jun 15, 2021 at 02:39:46PM +0100, Fuad Tabba wrote:
> > Add trap handlers for protected VMs. These are mainly for Sys64
> > and debug traps.
> 
> I think one big thing missing from this patch is some rationale around
> which features are advertised and which are not. Further, when traps
> are enabled later on, there doesn't seem to be one place which drives the
> logic, so it's quite hard to reason about.
> 
> So I think we need both some documentation to describe the architectural
> environment provided to protected VMs, but also a way to couple the logic
> which says "We hide this feature from the ID registers because of foo"
> with the logic that says "And here is the control bit to trap this feature".

I think it would be better to have documentation that says "We expose this
feature because foo". If the feature doesn't have any rationale to be
exposed, then it's just not. It may also make sense to document features
that should never be exposed, if there are features like that, in order to
ensure nobody comes along and exposes them later.

Thanks,
drew

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
