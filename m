Received: from mta1.migadu.com (out-138.mta1.migadu.com [95.215.58.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D732DB785
	for <kvmarm@lists.linux.dev>; Fri,  2 Oct 2026 07:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790925431; cv=none; b=MqRUPyfXzbbNEtrja7t/i2KFcB4HJvwBzxUmqa44JlJwrr1M2nhelwHbgIztuvct5SzvvL61a2TDQ6CLvtIucO3bDQZTbbI9qzA9aHNSm+ZCtSvSU7KW9RN0XtkXibXL/qCWbKaNcQ6hiJgOlMlOaA9j7HVC6LqM/Ie4BstdQvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790925431; c=relaxed/simple;
	bh=ZfS6OZATIkXgmF71OX5d8pzZikDejN8Iw6Et1wcr9GE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZrePKHs7ckcVVwpBwmjz2xXOmdEgUw5KW9WgSg5+nRH2b4SzwbFlB9f8UjJu2phF5RHrzyzJAzVYbx8D71RPLFDFdLCTVuS7ZoFtpD/Fbq6NuFNi+suvwEQLEzyR9kjNrQn9Vchxy5Wpu5EUZRE0/I9bnWlrWZMfMKyPJ2P0yqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Fqa4uEGh; arc=none smtp.client-ip=95.215.58.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Fqa4uEGh"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=ZfS6OZATIkXgmF71OX5d8pzZikDejN8Iw6Et1wcr9GE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790925426; v=1; x=1791530226;
 b=Fqa4uEGhKc3ICP5DpPImLLO2OdTCpaWNE7f4eCBCojzQS9TjAi3gP8HyMwWaCZUO08Zon49J
 ztiRphaqe5VJ/61uMGzdvlfRb21DUDlLsHdbtohhCiVpX5Na/L3W4V5CXxFe4xLLyguJCcLjeJm
 ppfBYG/MWTEMZwkbw6lP1c2Q=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 6897a09e0ddf1f6e;
	Fri, 02 Oct 2026 07:17:06 +0000
X-Mizu-Trace-ID: 6897a09e0ddf1f6e
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Itaru Kitayama <itaru.kitayama@linux.dev>
Cc: kvmarm@lists.linux.dev,
	Fuad Tabba <tabba@google.com>
Subject: Re: kselftest kvm/arm/page_fault_test hangs if pagesize is 16KB
Date: Fri,  2 Oct 2026 08:17:01 +0100
Message-Id: <20261002071701.2671016-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <B4C0AC3E-6A4F-4A7B-B7BC-81207539115E@linux.dev>
References: <B4C0AC3E-6A4F-4A7B-B7BC-81207539115E@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Itaru,

On Fri, 27 Jun 2025 07:34:57 +0100, Itaru Kitayama <itaru.kitayama@linux.dev> wrote:

[...]

> I checked testing with the 4KB and 64KB page sizes, page_fault_test runs fine.

I hit the same hang. It's a QEMU bug: with a 52-bit PA, the stage 1
walk computes the wrong base address for an initial table smaller than
64 bytes, such as the 16KB mode's level 0. I've posted a fix [1].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20261001175003.ttbr-baddr-52bit-0-fuad.tabba@linux.dev/
