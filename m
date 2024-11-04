Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 437411C6F70
	for <kvmarm@lists.linux.dev>; Mon,  4 Nov 2024 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730744966; cv=none; b=kALHba9DFsMG8CunwI6KWcDTVG8uSdgM4KJh+v7y+fc8OuPQ6YkT0uwML+MahgeC9oxrVaL1NaIXcVMwR4mdL7U9Av1HXCyEIipYN2QymK+6yMrH6XLHYveUkhS2IkwN0EcFHECT8cC6he9NBOGzJgRRbDcEX4meaZf93zWWJ6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730744966; c=relaxed/simple;
	bh=6zj3KWYygZTO2PivXmiZ1KU1e4n5TRnl8SpGGzWlJ40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CHgSFV56fX9937r2kEYrROgKG817BRJHXbp+Vix4EAF+cMBpvBVr7SP9vgH7ZfmS6LXzbK/NeimoGEU5YZw0ZWA4Vec6fB+CaGFWgjy6H5K8Rt2YNtqAcAEn8in9vLbT6+8fqGYVaXy5OHfxDk69RXpqvtDDO/EKJJ0/tVzaTf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N+f1qlyp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N+f1qlyp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730744963;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ib3dno1TrrtYfmoTnReQnF1SujY6XHyETaGD47xMgyM=;
	b=N+f1qlypwlA8tJJ8jCiTRwc4Ipv0eYFrRX+DzWHWv26PP9kJrBX5+6lnNH4XjNmYitOeng
	HVZKJ9Eqzx/ZnR2nUqraqwqDe97SuK1ZTLmw0vJ5qUHDcxQBB2tTIA8farWIIqxH0vbjDY
	43Phfo4Hw5Y3QdApw7XZRq6vJBYyG5k=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-338-5mZqUXsrOoupLswS_sX-DA-1; Mon,
 04 Nov 2024 13:29:20 -0500
X-MC-Unique: 5mZqUXsrOoupLswS_sX-DA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 791DE1955F07;
	Mon,  4 Nov 2024 18:29:16 +0000 (UTC)
Received: from pinwheel (unknown [10.39.193.180])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6F16F19560A3;
	Mon,  4 Nov 2024 18:29:06 +0000 (UTC)
Date: Mon, 4 Nov 2024 19:29:02 +0100
From: Kashyap Chamarthy <kchamart@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: eric.auger@redhat.com, eric.auger.pro@gmail.com, cohuck@redhat.com,
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	richard.henderson@linaro.org, alex.bennee@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, sebott@redhat.com,
	shameerali.kolothum.thodi@huawei.com, armbru@redhat.com,
	berrange@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
	pbonzini@redhat.com
Subject: Re: [RFC 21/21] arm/cpu-features: Document custom vcpu model
Message-ID: <ZykSbiUnb_ZclYCz@pinwheel>
References: <20241025101959.601048-1-eric.auger@redhat.com>
 <20241025101959.601048-22-eric.auger@redhat.com>
 <Zx__Zi3Zpg1AspnE@pinwheel>
 <52690aae-55b6-47d5-a308-dd75475f8377@redhat.com>
 <CAFEAcA9y5ooPNZ7JbGmRyTKbZn5XPK+5zZgVAvnER=++kWuBrg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFEAcA9y5ooPNZ7JbGmRyTKbZn5XPK+5zZgVAvnER=++kWuBrg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Nov 04, 2024 at 04:30:17PM +0000, Peter Maydell wrote:
> On Mon, 4 Nov 2024 at 15:34, Eric Auger <eric.auger@redhat.com> wrote:

[...]

> > > If possible, it would be really helpful (and user-friendly) to be able
> > > to specify the CPU feature names as you see under /proc/cpuinfo, and be
> > > able to turn the flags on or off:
> > >
> > >         -M virt -cpu franken,rndr=on,ts=on,fhm=off
> > >
> > > (... instead of specifying long system register IDs that groups together
> > > a bunch of CPU features.  If I understand it correctly, the register
> > > "ID_AA64ISAR0_EL1" maps to a set of visible features listed here:
> > > https://docs.kernel.org/arch/arm64/cpu-feature-registers.html)
> > Not all the writable ID regs are visible through the above technique.
> > But indeed I think we converged on the idea to use higher level feature
> > names than ID reg field values.
> > However we need to study the feasibility and mappings between those high
> > level features and ID reg field values.
> > The cons is that we need to describe this mapping manually. Besides
> > being cumbersome this is also error prone.
> 
> You might be interested in "Arm Architecture Features" on
> https://developer.arm.com/Architectures/A-Profile%20Architecture#Downloads
> which includes a 1.8MB Features.json which is a machine
> readable version of the "what are the features and their
> dependencies and ID registers and so on" information.

I just took a quick at the JSON file.  It was a bit difficult to get a
sense of the structure of the file.  Maybe it makes more sense to those
who are more Arm-aware than me.  Or maybe that's what you meant by
"alpha quality" below :)

Out of curiosity, I tried to find the features for the register
"ID_AA64ISAR0_EL1".  I was navigating via trial-and-error with `jq`.
There's a lot of "right"/"left" traversing:

    $> jq '.parameters[136]|.constraints[1]|.right|.left|.value' Features.json 
    "FEAT_TME"

The register name is buried under this:

    $> jq '.parameters[136]|.constraints[1]|.right|.right|.left|.arguments' Features.json 
    [
      {
        "_type": "Types.Field",
        "value": {
          "field": "TME",
          "instance": null,
          "name": "ID_AA64ISAR0_EL1",
          "slices": null,
          "state": "AArch64"
        }
      }
    ]


I was niavely expecting a more predictable structure such as:

    $> jq '.register[ID_AA64ISAR0_EL1]|.fields' Features.json
    FEAT_RNG
    FEAT_TLBIOS
    ...

> But note that (a) it is alpha quality and (b) I am not personally
> going to try to interpret what might be reasonable to do with it
> based on the legal notice attached to it: that's a matter for
> you and your lawyer ;-)

Hmm, it sounds like until point (b) is clarified, this file is out of
consideration from an upstream point of view.

> -- PMM
> 

-- 
/kashyap

