Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A23891DDA09
	for <kvmarm@lists.linux.dev>; Fri, 21 Mar 2025 15:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742571724; cv=none; b=OlRiiqbXXGr+qmRjv6q4NXkWg6E+g/K9gO5uLWjqYJMn7g57/yOVAABSVYkDXoFupXbzBD4prHyCmcT5KXTaOqBTJD7wVOhxrcrhBgoXgxdtYdyw6ZHRBSXecHzrFiznV/IvUpG4eOQeqTHgGQU3C/1a0aPQqrqQ3GRFmtdkmOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742571724; c=relaxed/simple;
	bh=7RqH5kytg89sTuOX53+jtbuhFNMPYRR0xwXsuTDnYYM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Rl/SY6TTR/WU69ENotd83MlveAtIIrUAN8pQ4kEGsEMy/rY3CfMQdWBtCODarfjSNYPMWXLWuxm18akBYdbPniQ0m4eVmlp+BXn4bmX1OJ4vKO733g4mkND4dkeDAkqDhZwy37MIvdj6Ums0zbqgdAOvXicTgkVFwudHEEcPkIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IJb6ptRS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IJb6ptRS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742571721;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rLAT+xNg6mpfaUskN/9jAwU3yywlq9mFubt3CKsbvCQ=;
	b=IJb6ptRSO7DhQ98azllrll4gxCmdBQVIMZtyZJ4tcsyTAyCckrtqVUmO/bYN23vd5nY81P
	dCP41ghPFySJRbu6NvE9TsjqWRkvrtlXmxJ7iEFCpUBmJidy/fjRgc32S36G1NEc23+WGp
	sN6W7VhkCBGfJaHujQf/pbhJactD55A=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-616-8FF16d2HNbGhKlCiBp_JZw-1; Fri,
 21 Mar 2025 11:41:57 -0400
X-MC-Unique: 8FF16d2HNbGhKlCiBp_JZw-1
X-Mimecast-MFC-AGG-ID: 8FF16d2HNbGhKlCiBp_JZw_1742571715
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BE6B0180AF4D;
	Fri, 21 Mar 2025 15:41:54 +0000 (UTC)
Received: from localhost (unknown [10.67.24.51])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 43B16180175A;
	Fri, 21 Mar 2025 15:41:50 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Sebastian Ott <sebott@redhat.com>
Cc: eric.auger.pro@gmail.com, eric.auger@redhat.com, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org, kvmarm@lists.linux.dev, peter.maydell@linaro.org,
 richard.henderson@linaro.org, alex.bennee@linaro.org, maz@kernel.org,
 oliver.upton@linux.dev, shameerali.kolothum.thodi@huawei.com,
 armbru@redhat.com, berrange@redhat.com, abologna@redhat.com,
 jdenemar@redhat.com, agraf@csgraf.de, shahuang@redhat.com,
 mark.rutland@arm.com, philmd@linaro.org, pbonzini@redhat.com
Subject: Re: [PATCH v3 13/14] arm/cpu: Add sysreg generation scripts
In-Reply-To: <17649857-752b-a149-3935-5bcbd5c50627@redhat.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20250311162824.199721-1-cohuck@redhat.com>
 <20250311162824.199721-14-cohuck@redhat.com>
 <17649857-752b-a149-3935-5bcbd5c50627@redhat.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 21 Mar 2025 16:41:44 +0100
Message-ID: <87pliatmpz.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Thu, Mar 20 2025, Sebastian Ott <sebott@redhat.com> wrote:

> On Tue, 11 Mar 2025, Cornelia Huck wrote:
>> +++ b/scripts/gen-cpu-sysregs-header.awk
> [...]
>> +BEGIN {
>> +    print ""
>> +} END {
>> +    print ""
>> +}
>> +
>> +# skip blank lines and comment lines
>> +/^$/ { next }
>> +/^[\t ]*#/ { next }
>> +
>> +/^Sysreg\t/ || /^Sysreg /{
>> +
>> +	reg = $2
>> +	op0 = $3
>> +	op1 = $4
>> +	crn = $5
>> +	crm = $6
>> +	op2 = $7
>> +
>> +	if (op0 == 3 && (op1>=0 && op1<=3) && crn==0 && (crm>=0 && crm<=7) && (op2>=0 && op2<=7)) {
>> +	    idreg = 1
>> +        } else {
>> +	    idreg = 0
>> +	}
>
> This doesn't seem to be used. I guess this is in preparation for later
> usage, when this can do more than just the plain register definition?

In fact, I might have got muddled a bit in my scripts, let me check. (I
think we should simply skip out-of-range regs.)

