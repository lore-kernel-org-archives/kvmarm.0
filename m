Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EEA381E92;
	Thu, 24 Sep 2026 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271441; cv=none; b=YG6vH6zXdHvDyoOrWCY+iDhGECI/zss7F2HKFgcMD+EOCX6bV04gsfLgF5MgoBabpKMwCyas5HldScUr77HsdWjzH860qvk4BI6gt9jjifrYp+oexwxyM/yx7AeR5uNztEQjtGF0d96Xy41spipCqsASKUCb+wjX4zra2dR/YJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271441; c=relaxed/simple;
	bh=5rWBun2zgOWirrL1sz3GNsGPwah7HP/7oMis5lFsSGw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DJac23Mgi39BX3oQxVTpv3NOkZ+ORuBZaTBbCiOcjxH+21lp6HlWv2cXuE8m6LGggmD7G5KcXoyQKCbmC6G2d72tFR6Fl4fz3lSyB+wJwd0CS2isslU3r//o4KciTX5Z62QiwmgrwsVs4dfKfo3lOJPF9J9vUlJwUPqaQmpACtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CsbUMDm2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CsbUMDm2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780FF1F000FF;
	Thu, 24 Sep 2026 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790271439;
	bh=5rWBun2zgOWirrL1sz3GNsGPwah7HP/7oMis5lFsSGw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CsbUMDm2Q5BoeLqMvoPxDk2d45dEyK3/UFyHUnVcKFx34flwNdBZJUGGk9WxxnySg
	 GNh5cksJkMbWcLIkFjl+ycmldONkAmE1CjEh+3x2vtDERDb3Pv0HZdioxeyTRR2lD0
	 5bYAKJrAWEo5ICqukC7W0RMoGFPQzbr/qHKBe03Vee/6tl3PGwC5hFowJTs0aEmYUR
	 SR4YbHRdo4fJHUMLEgv+Xg19T4+JQgDO2JG7Qu9t/GmPBLcHkbma9MfOKfo9UW76Ve
	 MVknVS3hBpwfU+vDexrYAKzgU9eBhsSIf/AdtV7Wcaiid0sKV1S1PFs7WmN4kEnpS8
	 v/ILRZV1pdksg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v9 04/22] perf: arm_pmuv3: Generalize counter bitmasks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Colton Lewis" <coltonlewis@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, "Oliver
 Upton" <oupton@kernel.org>, "Marc Zyngier" <maz@kernel.org>
In-Reply-To: <20260924172928.2110956-5-coltonlewis@google.com>
References: <20260924172928.2110956-1-coltonlewis@google.com>
 <20260924172928.2110956-5-coltonlewis@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 24 Sep 2026 17:37:19 +0000
Message-Id: <20260924173719.780FF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>

> The OVSR bitmasks are valid for enable and interrupt registers as well as
> overflow registers. Generalize the names.
>=20
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Colton Lewis <coltonlewis@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260924172928.2110=
956-1-coltonlewis@google.com?part=3D4

