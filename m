Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 136A818E1F
	for <kvmarm@lists.linux.dev>; Tue, 13 May 2025 15:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747151968; cv=none; b=uXFCBK8BVMfAuaQiHD7BPpbEYn1vStE7gqKi3gVC9MZowGcL3KOL8k+y2JwU5WsHxhTkR0D4gHOf9Ysm3noxaswXn7YB1s3PpSdW+bJrhNNbypJ3ZQQR6QCkkNprCCNJUcBIFBupVTn/CRJehbfxgG7x3VfiXvJ8csIyuWj6OHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747151968; c=relaxed/simple;
	bh=QvLwqNuxL1aL/lHumTRu/q1WrRaI8ocToOw3emFwpEs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j46KmhPDoXi6CHXzY8Wg2qwFvXQ/5oGniacmcnNA2oUmZvRPDH40HxBtWD7Lh5Np/8HQ8XEqx0EnhKLZSLYB9d62pHw6PpNDu7xC3bGEl6HXbHXZsOOsDH+Uue1rAVwrIIMx/qJ1ZBklN1aWNctav5YfeV5P8iqJ05xc7jcpNbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PQ1CUNbw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PQ1CUNbw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747151964;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=cpCyPlJZciumqABeN28iV1xD7w0u8enH0cNn7I7ljKI=;
	b=PQ1CUNbwnLO+H+AGxO98Ob5Y5FT7JYOKdVeghJXUOs+j4g8lDz2+RrZ45J3FP2H5P4eSz0
	RoY5RqtP3Qk5O/VYzUWu1yzGr+d6Yb/fEwmkGNa6ivo3+BYO5OkVV7QYoK7HdtkrJGqRHa
	H8hi2SQknFv4IfHELITLiAgg7PluBHo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-453-mvwAL7mfMS-wz8sakA9hjg-1; Tue,
 13 May 2025 11:59:21 -0400
X-MC-Unique: mvwAL7mfMS-wz8sakA9hjg-1
X-Mimecast-MFC-AGG-ID: mvwAL7mfMS-wz8sakA9hjg_1747151958
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 037E61955BC7;
	Tue, 13 May 2025 15:59:18 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.110])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4874B30002E3;
	Tue, 13 May 2025 15:59:10 +0000 (UTC)
Date: Tue, 13 May 2025 16:59:05 +0100
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
Message-ID: <aCNsSbDoi5oKWYul@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-9-cohuck@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250414163849.321857-9-cohuck@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Apr 14, 2025 at 06:38:47PM +0200, Cornelia Huck wrote:
> From: Eric Auger <eric.auger@redhat.com>
> 
> If the interface for writable ID registers is available, expose uint64
> SYSREG properties for writable ID reg fields exposed by the host
> kernel. Properties are named  SYSREG_<REG>_<FIELD> with REG and FIELD
> being those used  in linux arch/arm64/tools/sysreg. This done by
> matching the writable fields retrieved from the host kernel against the
> generated description of sysregs.
> 
> An example of invocation is:
> -cpu host,SYSREG_ID_AA64ISAR0_EL1_DP=0x0
> which sets DP field of ID_AA64ISAR0_EL1 to 0.

For the value you are illustrating 0x0 - is this implying that
all the flags take an arbitrary integer hex value ?

This would be different from x86, where CPU feature flags are
a boolean on/off state.

> [CH: add properties to the host model instead of introducing a new
> "custom" model]
> Signed-off-by: Eric Auger <eric.auger@redhat.com>

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

