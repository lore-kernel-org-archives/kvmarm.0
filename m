Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143CD27A442
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 18:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747246948; cv=none; b=Veyveyb7giy95nl0vlZu2fcE8Y2bn7vrgcjvIwExvFYZIi+F+4UawTWMBUrVZiZFu9ao1Fc7GZ4oMv1AWt6/eJ4aN6/Hutzgh7A7Ow26RLSp1pHINdtSjsLhO5H8+XBDdHtM3K6Xd8/5JL/x6/NzgHufZfEs2wk7jjI7LohG+Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747246948; c=relaxed/simple;
	bh=jbmaLe1rODb+DtAQ61FQd/wuKOVV4JndU4jbbUNACKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OdROfM+8cJrt9YmH4b8/snVYrW69sfB1pmZeJK4ENw4yErbjWrjK3KE/wjOD7aZ4D9D2zahexXrCPM44mCX3W+Fzvyhq7pvkVwY7K3Ergb+9PN4lT9yBHWPFs+g8ZuYLvH13H2NlnyLC5CcFobJNti2M+YUEkKR6Ld0ErmXZseM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EKVNiE72; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EKVNiE72"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747246946;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tPeRMIcrtB8JtU0o7I5k5bCudFUZhP2qzhPFFnVn9pE=;
	b=EKVNiE72Cy3wmqt8OyEHdmtNYo5CQFb7hDV/Jg97CSVnbYZ7XmANrFpf7BnzXIPMJu0mWc
	y2vtfAwc77iWMYBvUvOfKm3KoyxVcbOD49Os8gCUY1Y6tpRezLMw+EMqnTtXTs8jfIYJCQ
	3N4zqDJVtDFuMbHW4ydYNKChoSf+1VE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-621-XgSVwa3ROS2hjrpefnarRA-1; Wed,
 14 May 2025 14:22:22 -0400
X-MC-Unique: XgSVwa3ROS2hjrpefnarRA-1
X-Mimecast-MFC-AGG-ID: XgSVwa3ROS2hjrpefnarRA_1747246940
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4DA9B1956050;
	Wed, 14 May 2025 18:22:19 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.22])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E940A180087A;
	Wed, 14 May 2025 18:22:11 +0000 (UTC)
Date: Wed, 14 May 2025 19:22:08 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Cornelia Huck <cohuck@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
	qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	agraf@csgraf.de, shahuang@redhat.com, mark.rutland@arm.com,
	philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 08/10] arm/cpu: more customization for the kvm host
 cpu model
Message-ID: <aCTe5kEN1WdgZ74T@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-9-cohuck@redhat.com>
 <aCNsSbDoi5oKWYul@redhat.com>
 <875xi3cig5.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <875xi3cig5.fsf@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, May 14, 2025 at 05:36:58PM +0200, Cornelia Huck wrote:
> On Tue, May 13 2025, Daniel P. Berrangé <berrange@redhat.com> wrote:
> 
> > On Mon, Apr 14, 2025 at 06:38:47PM +0200, Cornelia Huck wrote:
> >> From: Eric Auger <eric.auger@redhat.com>
> >> 
> >> If the interface for writable ID registers is available, expose uint64
> >> SYSREG properties for writable ID reg fields exposed by the host
> >> kernel. Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
> >> being those used  in linux arch/arm64/tools/sysreg. This done by
> >> matching the writable fields retrieved from the host kernel against the
> >> generated description of sysregs.
> >> 
> >> An example of invocation is:
> >> -cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> >> which sets DP field of ID_AA64ISAR0_EL1 to 0.
> >
> > For the value you are illustrating 0x0 - is this implying that
> > all the flags take an arbitrary integer hex value ?
> >
> > This would be different from x86, where CPU feature flags are
> > a boolean on/off state.
> 
> Most of the fields are 4 bits, the allowed values vary (there are also
> some fields that are single bits, or wider.) The FEAT_xxx values (which
> can be expressed via ID register fields, or a combination thereof) are
> mostly boolean, but there are also some of them that can take values.
> 
> We could cook up pseudo-features that are always on/off, but I don't
> like that approach: they would be QEMU only, whereas the ID register
> fields and FEAT_xxx features are all defined in the Arm documentation.

Fortunately from a libvirt POV we can likely expand our config
to cope with hex values for arm features without too much
trouble.

> 
> An additional difference from x86 would be that FEAT_xxx featues are not
> neccessarily configurable (only if the host kernel supports changing the
> ID register field(s) backing the feature.)

Is the kernel able to tell us which ones are configurable and which
are not ? If so, it'd be helpful to expose this info in QAPI some
place.

> 

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

