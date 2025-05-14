Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5D713C3F6
	for <kvmarm@lists.linux.dev>; Wed, 14 May 2025 15:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747236396; cv=none; b=rZpBSaoyDTX+JVyA2R5qauYkFSN6wow/HSfMhJHELWnQhB9zOCWgwjrIpDTw2LwbWpLa1KnALVB7+Lkc+iaTutjGevdwjqNRDGrL5lkuuiKyguV20HET9ovU0fx5aihxTouo5g3xWZpr5p2wiPUo612pDIKd2Q71y3vuPDYUc0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747236396; c=relaxed/simple;
	bh=qy8tuXenn9jL1PckyCKda1AP19XJjjK6yPxR7ReOSZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KQWRNKQX7g2GMLa2Zsrq/pEE43xqjPdDxM1909pgyR6xk1hyRjnvJzXaytvFjqecI5/RGt4D9ly6r1hDVJkELzCG37eL4k/YQlMyp4ceV+TKlSrmBYpQNSfFFRCWSl5NvbvDMokEA8ur0Frfor9mRx4WCVbD0WQza+WRujM2UqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RAL8B29A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RAL8B29A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747236392;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YvXcEYB8GmnfSL56FqDCdhwjR6lZVlguKBnz4DxzyG8=;
	b=RAL8B29A729PUUO4QedxqY5GbmU/WSN1PuWkFuBwJ6a7w1Fd8UkXPnb700kboEP3jQEnJ5
	wf5it1W0XATKs9msW/uCzjAP2HOptgCill1gCgaG239E20tz4yUP3rihCf4/CuQkZcpE8D
	s06cx2MeBpMh/yz2HloxzgakxSi1vKY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-0QcoPX4xOl6EmAV5GTXP4w-1; Wed,
 14 May 2025 11:26:29 -0400
X-MC-Unique: 0QcoPX4xOl6EmAV5GTXP4w-1
X-Mimecast-MFC-AGG-ID: 0QcoPX4xOl6EmAV5GTXP4w_1747236387
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 52C1A180056F;
	Wed, 14 May 2025 15:26:26 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.147])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 763141955BC0;
	Wed, 14 May 2025 15:26:20 +0000 (UTC)
Date: Wed, 14 May 2025 16:26:17 +0100
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
Subject: Re: [PATCH v6 12/14] arm/cpu: Add sysreg generation scripts
Message-ID: <aCS2GbNCzQ3jc2ka@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250506085234.855779-1-cohuck@redhat.com>
 <20250506085234.855779-13-cohuck@redhat.com>
 <aCNwKBDtJES0GX3q@redhat.com>
 <87ecwrckfc.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87ecwrckfc.fsf@redhat.com>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, May 14, 2025 at 04:54:15PM +0200, Cornelia Huck wrote:
> On Tue, May 13 2025, Daniel P. Berrangé <berrange@redhat.com> wrote:
> 
> > On Tue, May 06, 2025 at 10:52:32AM +0200, Cornelia Huck wrote:
> >> From: Eric Auger <eric.auger@redhat.com>
> >> 
> >> Introduce scripts that automate the generation of system register
> >> definitions from a given linux source tree arch/arm64/tools/sysreg.
> >> 
> >> Invocation of
> >> ./update-aarch64-sysreg-code.sh $PATH_TO_LINUX_SOURCE_TREE
> >> in scripts directory generates target/arm/cpu-sysregs.h.inc
> >> containing defines for all system registers.
> >> 
> >> [CH: update to handle current kernel sysregs structure, and to emit
> >>      the re-worked register structures; cpu properties will be added
> >>      later]
> >> Reviewed-by: Sebastian Ott <sebott@redhat.com>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> >> ---
> >>  scripts/gen-cpu-sysregs-header.awk    | 35 +++++++++++++++++++++++++++
> >>  scripts/update-aarch64-sysreg-code.sh | 25 +++++++++++++++++++
> >>  2 files changed, 60 insertions(+)
> >>  create mode 100755 scripts/gen-cpu-sysregs-header.awk
> >>  create mode 100755 scripts/update-aarch64-sysreg-code.sh
> >> 
> >> diff --git a/scripts/gen-cpu-sysregs-header.awk b/scripts/gen-cpu-sysregs-header.awk
> >> new file mode 100755
> >> index 000000000000..b6b207e3c0fd
> >> --- /dev/null
> >> +++ b/scripts/gen-cpu-sysregs-header.awk
> >> @@ -0,0 +1,35 @@
> >> +#!/bin/awk -f
> >> +# SPDX-License-Identifier: GPL-2.0
> >
> > Invalid license name here - hopefully checkpatch.pl is warning
> > about this.
> 
> It might not check .awk scripts?

The existence of SPDX tags is only checked for .c, .h,
.py, .pl, .sh, .json & .inc

The validation of license names is checked unconditionally any time
the SPDX-License-Identifier tag is seen.

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|

