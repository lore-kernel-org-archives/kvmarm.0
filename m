Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1874CC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 20 Jul 2022 16:22:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EABD4D83E;
	Wed, 20 Jul 2022 12:22:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id p7SyjLG9aBkT; Wed, 20 Jul 2022 12:21:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 479464D845;
	Wed, 20 Jul 2022 12:21:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 075BB4D839
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 12:21:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i+NERp14i0qC for <kvmarm@lists.cs.columbia.edu>;
 Wed, 20 Jul 2022 12:21:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B3F694D831
 for <kvmarm@lists.cs.columbia.edu>; Wed, 20 Jul 2022 12:21:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1658334115;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 in-reply-to:in-reply-to:references:references;
 bh=RNk6IAipo4mh8LBH8MtO8K18i9SdfeqIGL3OSdVhBzg=;
 b=baJ5f2YOzwaFeqAvuQVYhAM+XQp9IG21OiA7wLswgsgEgySmmtBMoBcrN3cNF9ksYII6zL
 6IIEkr/p06anJU+I4IxvdQDxZ8RU8IsUg4EKjnz+C5nIOsgYAkl69JxYEUG9jlEcgBVvFo
 72H2gOUjpHVUyqHT77fetn0tsGTEalQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-RHYrurhEO5S1XqoXofI7Cw-1; Wed, 20 Jul 2022 12:21:49 -0400
X-MC-Unique: RHYrurhEO5S1XqoXofI7Cw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1877A8037AF;
 Wed, 20 Jul 2022 16:21:49 +0000 (UTC)
Received: from localhost (unknown [10.39.193.129])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id B2D4E2026614;
 Wed, 20 Jul 2022 16:21:48 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Peter Collingbourne <pcc@google.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: support MTE in protected VMs
In-Reply-To: <CAMn1gO65DJs8QyMs4YTmq7_b01qjLgBRhM3OLZ7aKaobEGMXDw@mail.gmail.com>
Organization: Red Hat GmbH
References: <20220708212106.325260-1-pcc@google.com>
 <877d49p36n.fsf@redhat.com>
 <CAMn1gO65DJs8QyMs4YTmq7_b01qjLgBRhM3OLZ7aKaobEGMXDw@mail.gmail.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date: Wed, 20 Jul 2022 18:21:47 +0200
Message-ID: <87k087oiuc.fsf@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvm@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, Andy Lutomirski <luto@amacapital.net>,
 Evgenii Stepanov <eugenis@google.com>, Michael Roth <michael.roth@amd.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Tue, Jul 19 2022, Peter Collingbourne <pcc@google.com> wrote:

> On Tue, Jul 19, 2022 at 7:50 AM Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> On Fri, Jul 08 2022, Peter Collingbourne <pcc@google.com> wrote:
>>
>> > Hi,
>> >
>> > This patch series contains a proposed extension to pKVM that allows MTE
>> > to be exposed to the protected guests. It is based on the base pKVM
>> > series previously sent to the list [1] and later rebased to 5.19-rc3
>> > and uploaded to [2].
>> >
>> > This series takes precautions against host compromise of the guests
>> > via direct access to their tag storage, by preventing the host from
>> > accessing the tag storage via stage 2 page tables. The device tree
>> > must describe the physical memory address of the tag storage, if any,
>> > and the memory nodes must declare that the tag storage location is
>> > described. Otherwise, the MTE feature is disabled in protected guests.
>> >
>> > Now that we can easily do so, we also prevent the host from accessing
>> > any unmapped reserved-memory regions without a driver, as the host
>> > has no business accessing that memory.
>> >
>> > A proposed extension to the devicetree specification is available at
>> > [3], a patched version of QEMU that produces the required device tree
>> > nodes is available at [4] and a patched version of the crosvm hypervisor
>> > that enables MTE is available at [5].
>>
>> I'm unsure how this is supposed to work with QEMU + KVM, as your QEMU
>> patch adds mte-alloc properties to regions that are exposed as a
>> separate address space (which will not work with KVM). Is the magic in
>> that new shared section?
>
> Hi Cornelia,
>
> The intent is that the mte-alloc property may be set on memory whose
> allocation tag storage is not directly accessible via physical memory,
> since in this case there is no need for the hypervisor to do anything
> to protect allocation tag storage before exposing MTE to guests. In
> the case of QEMU + KVM, I would expect the emulated system to not
> expose the allocation tag storage directly, in which case it would be
> able to set mte-alloc on all memory nodes without further action,
> exactly as my patch implements for TCG. With the interface as
> proposed, QEMU would need to reject the mte-shared-alloc option when
> KVM is enabled, as there is currently no mechanism for KVM-accelerated
> virtualized tag storage.

Ok, that makes sense.

>
> Note that these properties are only relevant for guest kernels running
> under an emulated EL2 in which pKVM could conceivably run, which means
> that the host would need to implement FEAT_NV2. As far as I know there
> is currently no support for NV2 neither in QEMU TCG nor in the Linux
> kernel, and I'm unaware of any available hardware that supports both
> NV2 and MTE, so it'll be a while before any of this becomes relevant.

Nod.

I'm mostly interested because I wanted to figure out how this feature
might interact with enabling MTE for QEMU+KVM. I'll keep it in mind.

Thanks!

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
