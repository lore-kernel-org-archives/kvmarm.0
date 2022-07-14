Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04374C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 14 Jul 2022 13:31:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DA644C5B9;
	Thu, 14 Jul 2022 09:31:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YWFnHN6-O0BU; Thu, 14 Jul 2022 09:31:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F0E604C563;
	Thu, 14 Jul 2022 09:31:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 552E24C4D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 09:31:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7361VSISSzV3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Jul 2022 09:31:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DA5F4C4CD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Jul 2022 09:31:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1657805461;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=3A2MgQ6BI+ZOeh/AAU41/XCV92zAyr9BTrgNi4g6/m4=;
 b=iMYkYmwXcXXarM/MU09cnLj279qFG57eqyhNe6PFX77cmYFSq6GRLzBpmxi4AdcesZFoY2
 /KESRfo9r/MLJFkd7HD3r/Q5TArEoMd/TFb7eu1Svo1SJ9t5HlgdFVG0BatWLSc9VbdRkL
 9/5KNgaJX7slneUM6OUJGhzvSYmtC9w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-349-E8geG59JNpCXsKJ8_zEn6w-1; Thu, 14 Jul 2022 09:30:57 -0400
X-MC-Unique: E8geG59JNpCXsKJ8_zEn6w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C4F1F8117B0;
 Thu, 14 Jul 2022 13:30:56 +0000 (UTC)
Received: from localhost (unknown [10.39.193.46])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5F239492C3B;
 Thu, 14 Jul 2022 13:30:56 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
In-Reply-To: <Ysg38XZSzPk8tYwK@xz-m1.local>
Organization: Red Hat GmbH
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com> <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
 <875ykmcd8q.fsf@redhat.com> <YrwRPh1S6qjzkJMm@arm.com>
 <7a32fde7-611d-4649-2d74-f5e434497649@arm.com> <871qv12hqj.fsf@redhat.com>
 <b91ae197-d191-2204-aab5-21a0aabded69@arm.com> <87bktz7o49.fsf@redhat.com>
 <Ysg38XZSzPk8tYwK@xz-m1.local>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date: Thu, 14 Jul 2022 15:30:54 +0200
Message-ID: <87edynizxt.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>, kvm@vger.kernel.org,
 Catalin Marinas <catalin.marinas@arm.com>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Steven Price <steven.price@arm.com>, Will Deacon <will@kernel.org>,
 Evgenii Stepanov <eugenis@google.com>, Michael Roth <michael.roth@amd.com>,
 Marc Zyngier <maz@kernel.org>, Chao Peng <chao.p.peng@linux.intel.com>,
 Andy Lutomirski <luto@amacapital.net>, Peter Collingbourne <pcc@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Fri, Jul 08 2022, Peter Xu <peterx@redhat.com> wrote:

> On Fri, Jul 08, 2022 at 03:03:34PM +0200, Cornelia Huck wrote:

>> I was thinking about a new flag that implies "copy metadata"; not sure
>> how we would get the same atomicity with a separate ioctl. I've only
>> just started looking at userfaultfd, though, and I might be on a wrong
>> track... One thing I'd like to avoid is having something that is too
>> ARM-specific, I think there are other architecture features that might
>> have similar issues.
>
> Agreed, to propose such an interface we'd better make sure it'll be easily
> applicable to other similar memory protection mechanisms elsewhere.

There's storage keys on s390, although I believe they are considered
legacy by now. I dimly recall something in x86 land.

>
>> 
>> Maybe someone more familiar with uffd and/or postcopy can chime in?
>
> Hanving UFFDIO_COPY provide a new flag sounds reasonable to me.  I'm
> curious what's the maximum possible size of the tags and whether they can
> be embeded already into struct uffdio_copy somehow.

Each tag is four bits and covers 16 bytes (also see the defs in
arch/arm64/include/asm/mte-def.h).

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
