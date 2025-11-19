Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9C23612F0
	for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763560110; cv=none; b=ePHK8zBp03Nd4TuzkKv6UONbuVF5fwhhHWNPs5Vb85KyymcG1JhOlE58uqd0C4WY0QR9F/oIGzXO3OlxYUi9rpt4q8JSEVBp3nbq9msZIxUfm1PoDxZB4Du/X8BcxmXOUxhKqT1v4heEHQWnWRgRZc1+acaXC88s/uqvJYL3vKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763560110; c=relaxed/simple;
	bh=dUZz/EGTXNyXTJb3zRKoJd5YmLpYLOqdOWG1Mal/clY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lR+DBv6N2Y2U9/It8+FjUjoZacnT9+avh+qFJ51p+G9uWAtfe6UL6hxTV3d8X5hSWC+haXAPCaQ9hRikUbsMqImdmE4wnYLLkUyUZhU+KwcVbsfD5Sk717e9VeqsI3plKPpAO89FnQ+ab7K/p4xgaGhOTEgvw1GA/n/7lIveWZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YlxjQZSK; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YlxjQZSK"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-477a219db05so24736495e9.2
        for <kvmarm@lists.linux.dev>; Wed, 19 Nov 2025 05:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763560107; x=1764164907; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dUZz/EGTXNyXTJb3zRKoJd5YmLpYLOqdOWG1Mal/clY=;
        b=YlxjQZSKiZEXID99iOzFbwgzm4aCTfx8zXrO9oTbc3SIadI+y4po0FY6f8wZ9YlYy8
         d002J/jJlEjcZsLgTzR5cB29E3Lrs7p6M16BbGJ52oHA6MVjXAxRFO+3IBtNB5/N3SXS
         YpPGOFaECSpbmK/LWRUr7VKD9RYx/FnoJQuY+fXC2Rt37Ag7ISUj+WJjIy/Bpr22WlQR
         aFl97FyeF72OYxzpCeMSO0LbQfLRQfaQRBviJDK0JfPSTVC20iyHB1ytG/pE0w6IJqYJ
         HaWSnb9QYbwJ1fJXfkaC01bqbH8dkOwzNavdWmuuUUaIzYapAZXGuphZg+HOnfc5TAxr
         dIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763560107; x=1764164907;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dUZz/EGTXNyXTJb3zRKoJd5YmLpYLOqdOWG1Mal/clY=;
        b=mBHStO6PIzvKmoXzEtpDczQdSCDNi/dmwM9Xew6hXXb7C6OsWdW3NNIkVYclBUgGGk
         0qIAuu2vJzdX8k0ih8jphnXhZ6r0ZuaImdTGms+maO8lIao/XnQZUaICS3xHlTVLbtCe
         NXViiS1X1zwSwM95fW5VcJxui0jiWn70+/g7veH82Mki8wmjeBHSlMLvOx8z0h0jcChI
         8K5cz2RSmRz2xGRfP2V2nJr3qf+nMymxI9PpLyb3sV0Ksw4Z2CrNGR+WcCSAv0ZwdCjy
         eeOIfi2kv6s8/yARaBZ/iGzxvRHApcn7owBf5hMAhFAU3q2A7hvO262gvti6t+9tvFnP
         /X5g==
X-Forwarded-Encrypted: i=1; AJvYcCVRYmm0jxBtlyFzfGwrxtBdJqf1riOvPzBHnziKcwJoqSlx07CaSOJzIseku5S3/6eCS3YaD7U=@lists.linux.dev
X-Gm-Message-State: AOJu0YycfeAjUEI7KD/jxXT3XBaKBaj9yMw83KpNPkS4y7h59NEQkl7T
	adfi/fWiRWdGDYBOiUVsoda/bfAZ2IvR1MVGzWlZaw3e82PHbuKSBc4J
X-Gm-Gg: ASbGncvVKMEJnuPAE2ITNNBNvALYI8P38a34nsIoLIwbpxybqyTS2UAlil6Ms2RPKIL
	gPWqlYWIvjX+rOIb0AA/caq+P5Q61RpB2xoe/yd7sJ2tJzToJIIpI2K42ZOgLEst7IA3GcPAIc+
	wlOodZTNskQEnc/d2cCbgukaCzGnduBtEJCx7L+xjFbsTRUdJB78thH3Y+xauaPKSsykdp+G8xs
	Bf/qGdT2BucT114QRFzq2L+zlGDUk+OHOSimozAxmiI6lnh2M8/VtYsRJrhH8QLyojVFD/DX2t2
	mPauk+D1uhy4JNvhB1mxOM4Im/pb3kFOK09VmFgt/L1AHqNMt3aDIQ3ocom6+/3i1BE6n4SijO+
	76HELhRG3P36wxeOu4Yes5eHYLl06cIPxzqYi7UyjzbEoW1VFSiyNolQF89AynihNjbb5vSsBUT
	7hvuiR/3LDwrdG1PX/NBa8aSKsoOI5MWI=
X-Google-Smtp-Source: AGHT+IEO/r2yjXRo1vsrIYmRAWR3LX5xjMNvgtEI6xtFpDqm0QsABV6tIyV/TEUGoCBLoYPW7a2THw==
X-Received: by 2002:a05:600c:3b19:b0:475:daba:d03c with SMTP id 5b1f17b1804b1-4778fe62088mr166989585e9.13.1763560107125;
        Wed, 19 Nov 2025 05:48:27 -0800 (PST)
Received: from smtpclient.apple ([132.68.46.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b106b03bsm50714925e9.9.2025.11.19.05.48.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Nov 2025 05:48:25 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20251119131827.GA2206028@e124191.cambridge.arm.com>
Date: Wed, 19 Nov 2025 15:48:13 +0200
Cc: kvm@vger.kernel.org,
 alexandru.elisei@arm.com,
 andrew.jones@linux.dev,
 kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D63D4CE9-431B-4F76-B769-C4FFB37B76AF@gmail.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20251119131827.GA2206028@e124191.cambridge.arm.com>
To: Joey Gouly <joey.gouly@arm.com>
X-Mailer: Apple Mail (2.3864.200.81.1.6)



> On 19 Nov 2025, at 15:18, Joey Gouly <joey.gouly@arm.com> wrote:
>=20
> On Thu, Sep 25, 2025 at 03:19:48PM +0100, Joey Gouly wrote:
>> Hi all,
>>=20
>> This series is for adding support to running the kvm-unit-tests at =
EL2. These
>> have been tested with Linux 6.17-rc6 KVM nested virt.
>>=20
>> This latest round I also tested using the run_tests.sh script with =
QEMU TCG,
>> running at EL2.
>>=20
>> The goal is to later extend and add new tests for Nested =
Virtualisation,
>> however they should also work with bare metal as well.
>=20
> Any comments on this series, would be nice to get it merged.

I wonder, does kvm-unit-tests run on bare-metal arm64 these days?

I ran it in-house some time ago (fixing several issues on the way),
but IIRC this issue was never fixed upstream:

=
https://lore.kernel.org/all/C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com=
/

