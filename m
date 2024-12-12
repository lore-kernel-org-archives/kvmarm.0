Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBFC13E40F
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 09:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733994645; cv=none; b=j5P9B0vHC427lCHh7znocYAY51ijytLiT8u3Mf9Bc35mTOIwN+FtJMTlbhxwLU6hl7YX9+e6BKtQWrcCSebXcqPk4cYhlEbzRqhT00ITWWWapQ4AxVr+O/ulamLpcxg38961k3BsDY8nHHKP08TyMcv/OrQIWFCuACrOq8b0ZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733994645; c=relaxed/simple;
	bh=WN+tvNijCCZBhbfkz+epBPjLO+CjJLabD9KxlJPYPag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ih6IQDtDZcIP7MrNwjUEH9RgzOqqYcZZ/DSZhNeYOT7sBocGZyucM8x1tNaaK3Pmz9Gwdy8+vjzE7ukyMzxlJFBH4oZi8CH3BRSIbeUMw8caMZNElf+CmwAVVCo82pTfJ8+KAMsygWEBOLCU1NlYwitCIHa2Gq9jM0TYLQAGQqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M6lA10Kb; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M6lA10Kb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733994640;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:in-reply-to:in-reply-to:  references:references;
	bh=BWZwaMWBF+qhMXgC83nMQPjAmVE6GP4sG+b/wKGZGzE=;
	b=M6lA10KbTTaR96AC7Nh/q57LvQo6CDgHvZ2TkAIFYxW4OzLK7fFuwpwoJJ9iTyCN1ffR++
	vnT93Iw/Lu5j+vyH0gkroriphNSCci/PF0AEHLs8U22V4g17sBVBpvdi2pw3IwgFMfM3vy
	0D0BDdoPtpHwHp/3cGViBxFe0+9vKwU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-261-iVBGIs7YPNuEYk4MjaSRCg-1; Thu,
 12 Dec 2024 04:10:36 -0500
X-MC-Unique: iVBGIs7YPNuEYk4MjaSRCg-1
X-Mimecast-MFC-AGG-ID: iVBGIs7YPNuEYk4MjaSRCg
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCC9C195604F;
	Thu, 12 Dec 2024 09:10:33 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.114])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B36BE195394B;
	Thu, 12 Dec 2024 09:10:26 +0000 (UTC)
Date: Thu, 12 Dec 2024 09:10:23 +0000
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Eric Auger <eric.auger@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, eric.auger.pro@gmail.com,
	qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvmarm@lists.linux.dev,
	peter.maydell@linaro.org, richard.henderson@linaro.org,
	alex.bennee@linaro.org, maz@kernel.org, oliver.upton@linux.dev,
	sebott@redhat.com, shameerali.kolothum.thodi@huawei.com,
	armbru@redhat.com, abologna@redhat.com, jdenemar@redhat.com,
	shahuang@redhat.com, mark.rutland@arm.com, philmd@linaro.org,
	pbonzini@redhat.com
Subject: Re: [PATCH RFCv2 00/20] kvm/arm: Introduce a customizable aarch64
 KVM host model
Message-ID: <Z1qoa8yXscTSAJ9e@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20241206112213.88394-1-cohuck@redhat.com>
 <edc12140-6345-4868-938d-c80c4d2c2004@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <edc12140-6345-4868-938d-c80c4d2c2004@redhat.com>
User-Agent: Mutt/2.2.13 (2024-03-09)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Dec 12, 2024 at 09:12:33AM +0100, Eric Auger wrote:
> Connie,
> 
> On 12/6/24 12:21, Cornelia Huck wrote:
> > A respin/update on the aarch64 KVM cpu models. Also available at
> > gitlab.com/cohuck/qemu arm-cpu-model-rfcv2

snip

> From a named model point of view, since I do not see much traction
> upstream besides Red Hat use cases, targetting ARM spec revision
> baselines may be overkill. Personally I would try to focus on above
> models: AltraMax, AmpereOne, Grace, ... Or maybe the ARM cores they may
> be derived from.

If we target modelling of vendor named CPU models, then beware that
we're opening the door to an very large set (potentially unbounded)
of named CPU models over time. If we target ARM spec baselines then
the set of named CPU models is fairly modest and grows slowly.

Including ARM spec baselines will probably reduce the demand for
adding vendor specific named models, though I expect we'll still
end up wanting some, or possibly even many.

Having some common baseline models is likely useful for mgmt
applications in other ways though.

Consider you mgmt app wants to set a CPU model that's common across
heterogeneous hardware. They don't neccessarily want/need to be
able to live migrate between heterogeneous CPUs, but for simplicity
of configuration desire to set a single named CPU across all guests,
irrespective of what host hey are launched on. The ARM spec baseline
named models would give you that config simplicity.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

