Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB5E1B043E
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 15:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747236584; cv=none; b=Kn3e3wYfie3V+c7rmAUNWZ6a1syz//tRrjsi7nLuNpaaeGULXIDHU/zL1lRp2/ZkJ6sdewiYuPU7PfDeGEEe+/NmgHQvK6e+zRn2qrLbhcDoVb9KafnrVpEA079pKNVXLwZK+KH/vv8bUHbuOUPeGfCHqEpl6iuyAYCruS18oH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747236584; c=relaxed/simple;
	bh=R3VKgFNOzOfdTeyrS2DrYH1ulbWf6Ea842eFti1Wqr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFpnOoiKtiZdUv3v4zJftoSSIEyU8DAeQwppXGpYSxY0iTuYC6try9nllweyu8mMZGe/KN6nLokFuk5SYiNKmtYUuB82xCt4DdI9WXcgGXUBc5EslnhOdhQPzD/G6Vm69PpePfls00g921bqmzRObuCixojW8UrifdD/TRizyAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fA9mDWP4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fA9mDWP4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747236581;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ujc5g4wP7awZPP/3/jYO0KhWUewU++24FB98JsLaKD0=;
	b=fA9mDWP498+PGxrdSIZ1WZa/UmWeKU0iV9g/SCqzCY0gewT3Xj3RiJRTeePZ5/pEFKJg61
	o596ZZCfJH9sfsS2FC0mIfSXuP2JFZX8ImX8GyKnUN/RvIaNsPp1VL8Lkzb8Yb6Mg5SYXT
	aaAiIg7LrU6BmedZRFma/owcE/3oFJQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-107-7PXd5x_dMUW1RklfQzMz_w-1; Wed,
 14 May 2025 11:29:38 -0400
X-MC-Unique: 7PXd5x_dMUW1RklfQzMz_w-1
X-Mimecast-MFC-AGG-ID: 7PXd5x_dMUW1RklfQzMz_w_1747236574
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BAE8E1800EC8;
	Wed, 14 May 2025 15:29:33 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.147])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54BB618004A7;
	Wed, 14 May 2025 15:29:27 +0000 (UTC)
Date: Wed, 14 May 2025 16:29:24 +0100
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
Subject: Re: [PATCH v3 02/10] arm/cpu: Add sysreg properties generation
Message-ID: <aCS21A8UmjEedTIP@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250414163849.321857-1-cohuck@redhat.com>
 <20250414163849.321857-3-cohuck@redhat.com>
 <aCNj4dFWLkBZrmmh@redhat.com>
 <878qmzciyg.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878qmzciyg.fsf@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Wed, May 14, 2025 at 05:25:59PM +0200, Cornelia Huck wrote:
> On Tue, May 13 2025, Daniel P. Berrangé <berrange@redhat.com> wrote:
> 
> > On Mon, Apr 14, 2025 at 06:38:41PM +0200, Cornelia Huck wrote:
> >> From: Eric Auger <eric.auger@redhat.com>
> >> 
> >> Introduce a script that automates the generation of system register
> >> properties definitions from a given linux source tree
> >> arch/arm64/tools/sysreg.
> >> 
> >> Invocation of
> >> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
> >> in scripts directory additionally generates
> >> target/arm/cpu-sysreg-properties.c containing definitions for
> >> feature ID registers.
> >> 
> >> update-aarch64-sysreg-code.sh additionally calls
> >> gen-cpu-sysreg-properties.awk which is inherited from kernel
> >> arch/arm64/tools/gen-sysreg.awk. All credits to Mark Rutland
> >> the original author of this script.
> >> 
> >> [CH: split off from original patch adding both sysreg definitions
> >>  and properties]
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> >> ---
> >>  scripts/gen-cpu-sysreg-properties.awk | 325 ++++++++++++++++++++++++++
> >>  scripts/update-aarch64-sysreg-code.sh |   5 +-
> >>  2 files changed, 329 insertions(+), 1 deletion(-)
> >>  create mode 100755 scripts/gen-cpu-sysreg-properties.awk
> >> 
> >> diff --git a/scripts/gen-cpu-sysreg-properties.awk b/scripts/gen-cpu-sysreg-properties.awk
> >> new file mode 100755
> >> index 000000000000..76c37938b168
> >> --- /dev/null
> >> +++ b/scripts/gen-cpu-sysreg-properties.awk
> >> @@ -0,0 +1,325 @@
> >> +#!/bin/awk -f
> >> +# SPDX-License-Identifier: GPL-2.0
> >
> > GPL-2.0 is a deprecated SPDX identifier. checkpatch.pl ought to
> > have complained about this, requiring GPL-2.0-or-later as the
> > preference, with GPL-2.0-only requiring justification in the
> > commit.
> 
> GPL-2.0 is inherited from the Linux script mentioned; not sure if
> GPL-2.0-only would be the correct fit here?

Yes, according to the table of deprecated terms at the bottom of

https://spdx.org/licenses/

GPL-2.0-only would indeed be the correct replacement.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

