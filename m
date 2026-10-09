Received: from mta1.migadu.com (out-117.mta1.migadu.com [95.215.58.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7113E40E9
	for <kvmarm@lists.linux.dev>; Fri,  9 Oct 2026 07:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791529896; cv=none; b=tW1sAtiyK1LQ3SCop3JiBbFpSv/6Q95ToggvRmD+FgFFISvHzmRiDHhCU4ZyGIazy2j4kWNug+R2Qji6le6wVitOzeG+1oyspBROlVZIlm7UbLO4XPtBsjdSARoNHCiDeo1fgd4hQ1zfI4R96/UdfsIvN8dP01am0J2N6yuOZsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791529896; c=relaxed/simple;
	bh=+3BT92sWytCvb3pLA/EXvyVT90nOy1CuxYDMO7Gq48Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/XWYV9tDsk2fgXETbsvhJ0OdC3Ub9OAU3olTgks3xjLQzTFpsp7DYnQUQd1NFxziJfgyPSzU/pr6HEtix/V/iZrveXClwPBRmrmWON9pCFDP0XXenn4VJc+3XY+ViJXDn40Pbk4EuDwoUrFGJeOEZ2EPg+/zVJhRcnbRTc/ysY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=sp82+7GS; arc=none smtp.client-ip=95.215.58.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="sp82+7GS"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=+3BT92sWytCvb3pLA/EXvyVT90nOy1CuxYDMO7Gq48Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791529893; v=1; x=1792134693;
 b=sp82+7GSHjgJuebi9o/DJLZ313HlD155t9ooWU7R9gmePwhg8tENw15eZg5fC0hVgDn5I5mk
 YauXmPuUBoTePDBBAisy4m8J3NcUxZsai6ImFIltOHmkOVlbOnHM3GONDlfX0Tt96F3ml+sQnqg
 XJbHyq5pnG4fcTbVHJPyLQ0c=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e352405b78ec7728;
	Fri, 09 Oct 2026 07:11:32 +0000
X-Mizu-Trace-ID: e352405b78ec7728
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5ba429b64c5so4711e87.1
        for <kvmarm@lists.linux.dev>; Fri, 09 Oct 2026 00:11:32 -0700 (PDT)
X-Gm-Message-State: AFq9FYJBMsedA2ibp/INi4z1jTr9NKNx7EFo0DN16U0DbEhUDlGyiCzm
	7VbBOhAPFoxbbA52v09PpWpe72KQhLgpvt6ta8cQCbcKlfk03s+BTQr5FyVSYbEgcEv7rEIHd9v
	c7lRmKC59X2cXT4kLmxqLZSHR3d1Q+xPcNS902Nt+
X-Received: by 2002:a05:6512:1194:b0:5b1:5141:9156 with SMTP id
 2adb3069b0e04-5bcdf948dc0mr43820e87.9.1791529891928; Fri, 09 Oct 2026
 00:11:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260831192406.1341841-1-fuad.tabba@linux.dev>
In-Reply-To: <20260831192406.1341841-1-fuad.tabba@linux.dev>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Fri, 9 Oct 2026 08:10:55 +0100
X-Gmail-Original-Message-ID: <CA+EHjTwBXEVp_fJp+SvXqrfab2NGdnCXy6L9n=aW2yeTUUOniQ@mail.gmail.com>
X-Gm-Features: AclHuK9OgMQfIJ6sfKoLoA9wmDjNzBE48OI8X_B1wQUZOUjYO1IsWkWO-9TV2hY
Message-ID: <CA+EHjTwBXEVp_fJp+SvXqrfab2NGdnCXy6L9n=aW2yeTUUOniQ@mail.gmail.com>
Subject: Re: [PATCH kvmtool 0/5] Fix diagnostics and capability probes for
 protected VMs
To: kvm@vger.kernel.org
Cc: kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Julien Thierry <julien.thierry.kdev@gmail.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Andre Przywara <andre.przywara@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Will,

Gentle ping on this series. Marc has merged the pKVM core series into
kvmarm/next, including the KVM_GET_ONE_REG -EPERM that patch 1
handles, and all five patches have Suzuki's Reviewed-by.

Cheers,
/fuad
