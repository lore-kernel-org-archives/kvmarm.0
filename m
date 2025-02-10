Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3414935972
	for <kvmarm@lists.linux.dev>; Mon, 10 Feb 2025 15:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739200842; cv=none; b=j5xU6bLgpH2cvz+tN1ee3iddx01rzwuZPxaGfZ4Ny/ry1/BMa7akCG+hbwj90itxIIV0XhwOQx/gG/dQ1tcs71SKoVq9lesJxnavhjYXYOD3LeToPyNg35xjFgU9jtchmd6crOwX44zZb0KiZp90EkB4sMknIdaHnxIY6JqLM1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739200842; c=relaxed/simple;
	bh=L5OT+59C3iT4MQ/lC2n03E8ed7rGkqDhCwJBIDscTR8=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bn5VFj8ORB4BfnVY5vUceDEwLOQ75X87efpoSttI/Xef3k6UVHgQD5qOiuPDUjQCLeSRz6ED+E4aDfPoOOKph+3KB/1a0YG5YkQ+fzsMlhs1GeUIz7ZEwpNviimTk1Ahx6VNhcnrhJ8ewriGLL7dK0AyezoSQF3lMpHkcRaj3gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EQiTcuHC; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EQiTcuHC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739200840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=l+1vKWq8tav0v5vOrEs4bMdzd3ftwt2N0noMcIDxK+A=;
	b=EQiTcuHCGLK2iUoaOgNxAp6gav4BRR7x1Tlu8F1KwWKsEyttULskewPpEXhQnUlCgPMkLL
	VZw3zmeHrzpIG964Y1k7fuZ33bXwbl3ej/x2UV3iMFcSz+nuYb67C81CI87Bh7T9HVBgPc
	ll52WZKZCxnDyetkSIw2XJ0jewSkG1A=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-dgWwLAmSMn2f19JyAWRGdQ-1; Mon,
 10 Feb 2025 10:20:36 -0500
X-MC-Unique: dgWwLAmSMn2f19JyAWRGdQ-1
X-Mimecast-MFC-AGG-ID: dgWwLAmSMn2f19JyAWRGdQ
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BA59D19560B1;
	Mon, 10 Feb 2025 15:20:31 +0000 (UTC)
Received: from localhost (unknown [10.45.225.231])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F032D30001AB;
	Mon, 10 Feb 2025 15:20:30 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Richard Henderson <richard.henderson@linaro.org>, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 15/15] arm/cpu: Add generated files
In-Reply-To: <f5878231-79b8-4e29-bfb0-f9a57ac3f6a4@linaro.org>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250207110248.1580465-1-cohuck@redhat.com>
 <20250207110248.1580465-16-cohuck@redhat.com>
 <f5878231-79b8-4e29-bfb0-f9a57ac3f6a4@linaro.org>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Mon, 10 Feb 2025 16:20:28 +0100
Message-ID: <874j117rnn.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Fri, Feb 07 2025, Richard Henderson <richard.henderson@linaro.org> wrote:

> On 2/7/25 03:02, Cornelia Huck wrote:
>> And switch to using the generated definitions.
>> 
>> Generated against Linux 6.14-rc1.
>> 
>> Signed-off-by: Cornelia Huck<cohuck@redhat.com>
>> ---
>>   target/arm/cpu-sysreg-properties.c | 716 ++++++++++++++++++++++++++++-
>>   target/arm/cpu-sysregs.h           | 116 +----
>>   target/arm/cpu-sysregs.h.inc       | 164 +++++++
>>   3 files changed, 860 insertions(+), 136 deletions(-)
>>   create mode 100644 target/arm/cpu-sysregs.h.inc
>
> Why are we committing generated files and not generating them at build-time?

We'd either have to carry a copy of Linux' sysregs file, or generate a
build dependency on Linux. I think we should handle this similar to the
Linux headers update, where we do an explicit update and check for
anything unexpected that might have crept in. (Same applies if we switch
to any other external source for register definitions.)

