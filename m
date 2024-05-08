Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B7F8120C
	for <kvmarm@lists.linux.dev>; Wed,  8 May 2024 12:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715170006; cv=none; b=s5EqMekVXQ6vSp+ccYAx3I3J1dIw3zrGMxxy6Z7mwkN6Tit6L+xEiBpsXytzuu/98flwLYHcv/E8Rqnsd17TFN7VKu8Ixa32IGW1T7fC29msnMLYWIQ7oqSANygbiAzP3dTJ3dYJ0XvnW2Nt0ES7v2eINOzzsPs1l6DtFjZFRhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715170006; c=relaxed/simple;
	bh=bKyCsGOMVlyNwjcJXiPjFyadd2zRhY9E7O4BYBOl4RE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YYmI9gXgfSF6R9sTq3sbkd/FPOfdNVHO4mcQQ9QCwcxSQffGXcPdsCFRbjp4SxhpJ13hZiNCf8BcrtyN57gCxjCVBHSGEKVnJ9nimraAEvJguyouqrUKUzajqMB8qBtwrIaFnqw8/VdUQATr1wWGwtNTQi2jpyoO1mUKyVRtWj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RiaXjsP/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RiaXjsP/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715170003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kch4CR6jb0EO3CtRVrd4DZN/+JzXwlHyRHSCeA2eEfY=;
	b=RiaXjsP/Yo7okPK4tCwS5k5Mywc5Rj4xudC0XfhKArxvVsplJ0ojbU5si87nqixwmDBxlQ
	4LLVQ69mgo5zqMZXTeWXic1wul1P8YXxnjpvOwI8+5rjDK2ohrOBapi2fu+CzbRfnyJ2+q
	WNC0GXZS1JI/0E2gFXjJfTG8qjmVXvk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-x3CuWCx9O8KAM64vBGyp9A-1; Wed, 08 May 2024 08:06:39 -0400
X-MC-Unique: x3CuWCx9O8KAM64vBGyp9A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7C5BF80021D;
	Wed,  8 May 2024 12:06:38 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C9B787414;
	Wed,  8 May 2024 12:06:37 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>, "Russell King (Oracle)"
 <linux@armlinux.org.uk>
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, James Morse
 <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui
 Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev
Subject: Re: [PATCH RFC] KVM: arm64: allow ID_MMFR4_EL1 to be writable
In-Reply-To: <ZjPDQSeQPE2wgVup@linux.dev>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <E1s2DPv-00AhaA-Ra@rmk-PC.armlinux.org.uk>
 <ZjKCgIyWqNKC6TUu@linux.dev> <ZjKFBUXEhwZ7ZmMM@shell.armlinux.org.uk>
 <ZjKRBcAML5T6cm4q@linux.dev> <ZjOl5hwU7yPXk8gs@shell.armlinux.org.uk>
 <ZjPDQSeQPE2wgVup@linux.dev>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Wed, 08 May 2024 14:06:36 +0200
Message-ID: <87jzk4h5ir.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

On Thu, May 02 2024, Oliver Upton <oliver.upton@linux.dev> wrote:

> On Thu, May 02, 2024 at 03:40:38PM +0100, Russell King (Oracle) wrote:
>> On Wed, May 01, 2024 at 06:59:17PM +0000, Oliver Upton wrote:
>> > On Wed, May 01, 2024 at 07:08:05PM +0100, Russell King (Oracle) wrote:
>> > > Yes, it did strike me as odd, since the description seems to imply that
>> > > XNX affects EL2, which the VM wouldn't have access to. So I'm not sure
>> > > why we don't just force it to zero.
>> > 
>> > Probably because we failed to catch it in the first place and setting to
>> > 0 now would be even more UAPI breakage. Meh :-/ I don't see any immediate
>> > issues with the patch, especially since it is fixing a genuine UAPI
>> > breakage in KVM.
>> 
>> I think the only two ways around this would be to:
>> 
>> 1) teach QEMU about the contents of these registers, with which fields
>>    in these registers can be ignored when reloading a VMs context.
>> 
>> 2) allow userspace to write to the XNX field such that it can be set
>>    to values seen with previous kernels (thus allowing at least one-
>>    way migration.)
>> 
>> (1) has the advantage that reloading a VM state on older vs newer
>> kernels can work in either direction, whereas (2) would only work
>> for state saved on an older kernel loaded onto a newer kernel.
>
> Yeah, so this is something that has affected my employer as well.
>
> I think (1) should only be expected of VMMs that want rollback safety,
> i.e. the ability to migrate state back to an older kernel. Our userspace
> initializes vCPUs from a fixed set of feature ID register values that
> prevents VMs on new kernels from picking up new CPU features.
>
> It is quite tedious, but necessary as rollback safety is very much a
> non-goal of the KVM UAPI.

Depending on your use case, rollback safety might be quite
important... have we ever stated exactly which guarantees the KVM UAPI
is giving? IOW, can someone implementing a VMM look at a doc and see
"oh, if I want to be able to go backwards, I need to be able to deal
with x, y, and z coming up on the new kernel"?

>
> OTOH, in cases where KVM screws up and breaks UAPI, the kernel needs to
> do something special to accept the previously-advertised state even if
> it were nonsensical.
>
> For example, there was a bug where KVM advertised an IMP DEF PMU to VMs
> even though the only thing KVM virtualizes is PMUv3. We fixed it in
> commit f90f9360c3d7 ("KVM: arm64: Rewrite IMPDEF PMU version as NI") by
> accepting the old value in the ioctl and changing the field to NI
> internally.
>
> I dislike these sort of hacks, but when we're caught between upholding
> UAPI and the architecture it seems to be the best option. I wonder if an
> approach similar to this would be sufficient to address the SPE change
> that you noticed.
>
>> I've been bitten before with KVM differences between kernel versions
>> in the past - where the number of registers that userspace sees has
>> changed despite being on the same hardware.
>
> This is intended behavior, as VMs are initialized to the maximum feature
> set KVM is able to support. Forward-compatibility for the set of exposed
> registers is tested, see the get-reg-list selftest.

I've seen this problem come up as well; if it is clear that this is
something that KVM expects the VMM to handle if needed, that is fine;
should we consider "it's tested in a selftest" as a canonical indicator
of "this is what KVM supports compatibility wise"?

