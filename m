Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5B0225419
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 15:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734620867; cv=none; b=U1Bx+DAiiQVm7ztvlCbn3vwZ1fDK9Axa1nHp1g/V5FtvX3AY8LROXUpDg7oyTs7Pqh457W5T5H5mAYBf3TN2alPQeLXSbxw6Wxy6D4WTX5iFUUozby/PvLYyHtAk9x2JgHZ8xRs5BZByt1ZDMj0ckJmdQgj5X8pYF2QB1/PyiSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734620867; c=relaxed/simple;
	bh=wqAKdZAdF+W9LhXzx7rxObKAXjvfksdRDkXvfAyVyis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FxN0IYqPH7PjkLJz90XfBoINLwDbOPw4yzWX2P7yrCoePxlh9nfxpcWzucbp1bwPGZtR/zLOoVltIbMZmCNqMvVfN3JD+E5lBZ7q2VTXKbuG2/1mwk5Lsk1xlouG4B8s3eJsyhmeOl+DwWVj2ZnrdbYCkwfS6zvBwbQN0oJ0xYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Rl20GiG7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rl20GiG7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734620863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wqJBuYXBM5bGC0okEKv667agh0vor0ZISW3sxUS0Cc8=;
	b=Rl20GiG7JO6D9p4GBnFSALJt8a64kIb9chr8W2oUnlSF4AvfyBgFU/gDvbQpTTnRcwfTI2
	g+/+oDo/SbYLV+d3ELagViHO/PDz7vbs0uvOEaUWbJDRmnPYCC84WfKE/oSijr/aAd5L/X
	J5yFrF6kpue0aB2q4LwqZePmK0x2Mc0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-258-g6hoKwx6OmivKsEvNQtaLw-1; Thu,
 19 Dec 2024 10:07:40 -0500
X-MC-Unique: g6hoKwx6OmivKsEvNQtaLw-1
X-Mimecast-MFC-AGG-ID: g6hoKwx6OmivKsEvNQtaLw
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C5F8E195608A;
	Thu, 19 Dec 2024 15:07:37 +0000 (UTC)
Received: from gezellig (unknown [10.39.193.32])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F83C195608A;
	Thu, 19 Dec 2024 15:07:28 +0000 (UTC)
Date: Thu, 19 Dec 2024 16:07:25 +0100
From: Kashyap Chamarthy <kchamart@redhat.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Eric Auger <eric.auger@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
	Daniel =?iso-8859-1?B?IlAuIEJlcnJhbmfpIg==?= <berrange@redhat.com>,
	eric.auger.pro@gmail.com, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, oliver.upton@linux.dev, sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
	abologna@redhat.com, jdenemar@redhat.com, shahuang@redhat.com,
	mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64
 KVM host model
Message-ID: <Z2Q2rWj9cV0W_XVq@gezellig>
References: <20241206112213.88394-1-cohuck@redhat.com>
 <edc12140-6345-4868-938d-c80c4d2c2004@redhat.com>
 <Z1qoa8yXscTSAJ9e@redhat.com>
 <8734it1bv6.fsf@redhat.com>
 <1fea79e4-7a31-4592-8495-7b18cd82d02b@redhat.com>
 <Z2QE9AqZnpGM5sWD@gezellig>
 <8634ijrh8q.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8634ijrh8q.wl-maz@kernel.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, Dec 19, 2024 at 12:26:29PM +0000, Marc Zyngier wrote:
> On Thu, 19 Dec 2024 11:35:16 +0000,
> Kashyap Chamarthy <kchamart@redhat.com> wrote:

[...]

> > Consider this:
> > 
> > Say, there's a serious security issue in a released ARM CPU.  As part of
> > the fix, two new CPU flags need to be exposed to the guest OS, call them
> > "secflag1" and "secflag2".  Here, the user is configuring a baseline
> > model + two extra CPU flags, not to get close to some other CPU model
> > but to mitigate itself against a serious security flaw.
> 
> If there's such a security issue, that the hypervisor's job to do so,
> not userspace. 

I don't disagree.  Probably that has always been the case on ARM.  I
asked the above based on how QEMU on x86 handles it today.

> See what KVM does for CSV3, for example (and all the
> rest of the side-channel stuff).

Noted.  From a quick look in the kernel tree, I assume you're referring
to these commits[1].

> You can't rely on userspace for security, that'd be completely
> ludicrous.

As Dan Berrangé points out, it's the bog-standard way QEMU deals with
some of the CPU-related issues on x86 today.  See this "important CPU
flags"[2] section in the QEMU docs.  

Mind you, I'm _not_ saying this is how ARM should do it.  I don't know
enough about ARM to make such remarks.

    * * *

To reply to your other question on this thread[3] about "which ABI?"  I
think Dan is talking about the *guest* ABI: the virtual "chipset" that
is exposed to a guest (e.g. PCI(e) topology, ACPI tables, CPU model,
etc).  As I understand it, this "guest ABI" should remain predictable,
regardless of:

  - whether you're updating KVM, QEMU, or the underlying physical
    hardware itself; or
  - if the guest is migrated, live or offline

(As you might know, QEMU's "machine types" concept allows to create a
stable guest ABI.)


[1] "CVE3"-related commits:
    - 471470bc7052 (arm64: errata: Add Cortex-A520 speculative
      unprivileged load workaround, 2023-09-21)
    - 4f1df628d4ec (KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV3=1 if the
      CPUs are Meltdown-safe, 2020-11-26)
[2] https://www.qemu.org/docs/master/system/i386/cpu.html#important-cpu-features-for-intel-x86-hosts
    - "Important CPU features for Intel x86 hosts"
[3] https://lists.nongnu.org/archive/html/qemu-arm/2024-12/msg01224.html

-- 
/kashyap

