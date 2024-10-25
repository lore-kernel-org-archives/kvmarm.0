Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B5214D6EF
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 14:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729867899; cv=none; b=J8hoMOK2tqsb1uwc7/F/Oxm+A3kq96I7gP5ox+V18hyMwxDE3QhG88Fchw51aezgyqatfzoXUjRzuayCZuZHyvKriI+uUaaIl78lxZVY9NwGBosYKKkqkns9NmyjwCPXfXVe1lzncJjUOTBliwiNhShG5pKSl4zfrDtOzC9CnMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729867899; c=relaxed/simple;
	bh=LoF4RYWvpaS0vW5bEAgiNQNr9BHLmXPkOOhNO9UDJtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/OmneCp4tSbGSVWj7qkZa5OHTe/VV0UySKnUIPGY0xU5mefj06NhI+3QJlq8vfh1/qQpmIKS0kg1TL8BS6DvmplvLUu0AFq8uPMh2c43yjNlg0leKZr08b08ex0bl2x+NKKk9eLYeWNHxUGqyCj3cci3cT+QMqE0PQRYw0AevQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pq19XceS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pq19XceS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729867896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oCATtNYUN/GH6SdVzjWLD+NRphY1brBLxdU6nbHifzE=;
	b=Pq19XceSrxuA3mOMmghXSh32ox0SWsPXgGEKvzlkSqsQbA8OnWWVZC6D26smoPQ3sHXBes
	Rn9WclrTi4R8uOXXPTKjZGiM+V2N1T440Zjt2mw92Pp0U0yMu/bem3LHlPi9xQLd2s9r7s
	1PTeoygRQcBojW6OYnbK8HWXio2DyvI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-vvtCLRQwPH6-Gn7xQefQPA-1; Fri,
 25 Oct 2024 10:51:32 -0400
X-MC-Unique: vvtCLRQwPH6-Gn7xQefQPA-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA9EC19560A6;
	Fri, 25 Oct 2024 14:51:30 +0000 (UTC)
Received: from pinwheel (unknown [10.39.208.23])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 09383300018D;
	Fri, 25 Oct 2024 14:51:22 +0000 (UTC)
Date: Fri, 25 Oct 2024 16:51:19 +0200
From: Kashyap Chamarthy <kchamart@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, cohuck@redhat.com, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
	jdenemar@redhat.com, shahuang@redhat.com, mark.rutland@arm.com,
	philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [RFC 00/21] kvm/arm: Introduce a customizable aarch64 KVM host
 model
Message-ID: <ZxuwZw2plMI6dNyE@pinwheel>
References: <20241025101959.601048-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025101959.601048-1-eric.auger@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Oct 25, 2024 at 12:17:19PM +0200, Eric Auger wrote:

Hi Eric,

I'm new to Arm, so please bear with my questions :)

> This RFC series introduces a KVM host "custom" model.

(a) On terminology: as we know, in the x86 world, QEMU uses these
    terms[1]:

    - Host passthrough
    - Named CPU models
    - Then there's the libvirt abstraction, "host-model", that aims to
      provide the best of 'host-passthrough' + named CPU models.

    Now I see the term "host 'custom' model" here.  Most
    management-layer tools and libvirt users are familiar with the
    classic terms "host-model" or "custom".  If we now say "host
    'custom' model", it can create confusion.  I hope we can settle on
    one of the existing terms, or create a new term if need be.

    (I'll share one more thought on how layers above libvirt tend to use
    the term "custom", as a reply to patch 21/21, "arm/cpu-features:
    Document custom vcpu model".)

(b) The current CPU features doc[2] for Arm doesn't mention "host
    passthrough" at all.  It is only implied by the last part of this
    paragraph, from the section titled "A note about CPU models and
    KVM"[3]:

      "Named CPU models generally do not work with KVM. There are a few
      cases that do work [...] but mostly if KVM is enabled the 'host'
      CPU type must be used."

    Related: in your reply[4] to Dan in this series, you write: "Having
    named models is the next thing".  So named CPU models will be a
    thing in Arm, too?  Then the above statement in the Arm
    'cpu-features' will need updating :-)

[...]

> - the QEMU layer does not take care of IDREG field value consistency.
>   The kernel neither. I imagine this could be the role of the upper
>   layer to implement a vcpu profile that makes sure settings are
>   consistent. Here we come to "named" models. What should they look
>   like on ARM?

Are there reasons why they can't be similar to how x86 reports in
`qemu-system-x86 -cpu help`?  

E.g. If it's an NVIDIA "Grace A02" (Neoverse-V2) host, it can report:

    [gracehopper] $> qemu-kvm -cpu help
    Available CPUs:
      gracehopper-neoverse-v2
      cortex-a57 (deprecated)
      host
      max

Or whatever is the preferred nomenclature for ARM.  It also gives users
of both x86 and ARM deployments a consistent expectation.  

Currently on a "Grace A02" ("Neoverse-V2") machine, it reports:

    [gracehopper] $> qemu-kvm -cpu help
    Available CPUs:
      cortex-a57 (deprecated)
      host
      max

I see it's because there are no named models yet on ARM :-)

[...]

[1] https://www.qemu.org/docs/master/system/i386/cpu.html
[2] https://www.qemu.org/docs/master/system/arm/cpu-features.html
[3] https://www.qemu.org/docs/master/system/arm/cpu-features.html#a-note-about-cpu-models-and-kvm
[4] https://lists.nongnu.org/archive/html/qemu-arm/2024-10/msg00891.html


-- 
/kashyap

