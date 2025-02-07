Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0095C238D2E
	for <kvmarm@lists.linux.dev>; Fri,  7 Feb 2025 14:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738940084; cv=none; b=XgHOGW4Adfe5/ViWlWyMc2ni5+DOGUQkRDLrOnsfb6qKIf20F/0jzgw4fkzZkZS5zfAHEt3Q0s0AEVNmeOFqqIe1oS//Y+EJ6nQ82pN5yL307cwItawMzR1TPhDi3HwWx9iQabtxfWZvKpOxwQT2TDMyD1oakXtOxy2M3RnFtQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738940084; c=relaxed/simple;
	bh=dhBxKIvdI6BiG9BZMMoSBVS3E3wXSa546KCeyQUs5Vs=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=f5zQuA++hoP9LWH1/vVlw1ndM8mRutWiacPQd1zPcI4CexVWFEFs2L/Uy2c89s/lPy8Knu5IMSxBki3QnzIm5OXblRbQDgo8kjOEnZzS4q0VneCwaSPKlpjH+vXPQURmtgnDSFVx7VKtvNFrTTVbv9JV+PXsZ02Hg8kl8OmXlug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=32C53PpT; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--qperret.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="32C53PpT"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aa689b88293so261423766b.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Feb 2025 06:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738940081; x=1739544881; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JmM/iQkbvbBvv7fXX70IILA144cHjP/mqwSWag+vGNY=;
        b=32C53PpTxFogoXIpX8WY6xvq3Xx4bDU7iKAamepY6B7+monWFGlOd7euq48am2DVz3
         mh0wRkZuKZewQfKDSV6EV7s0VmP6rmrFsJy1bT5RtWsQITJESkslQZGWSvkaXofFtBvf
         gQOi+eLAc+xUdNVkeP21LN0pYtImTv8C/fLp5pEIqjSM8BY/tvOOSb848ecKEhpw06Xi
         OSn/yOdo8qE2gzYk4NLyiEMafQ3shGDs2brWaMnyKFA7/9Mfc2mk4Lmpa+mGyoagze6y
         bVMbocrcA+ggd8G++wviS65kJC+WRCDXMoJF66B4sLftmUu+tH775FQ1IT/JxBj/ka6v
         UfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738940081; x=1739544881;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JmM/iQkbvbBvv7fXX70IILA144cHjP/mqwSWag+vGNY=;
        b=GGEr3bDviPstPZpIHaZ68kACkXz3EemS1r+sO4yQi/DvC3shRlcLanXMUrIfbaDVML
         fqWbtfyxGg80rVEw7hDBr8vFREkOQSPyZ59oWmF/jihZGqpw0YedjuNw6waBVpPxwaND
         ZN0umfCvCH2YsXn1q+4leQt4yIuPk5NjaMuICr4GdI/kDGEWqA7ymn8KTYgsf6wLXr3l
         ABFtee0O5HPh2YT+KAjKCKuiFnEYeND4wDQOi7GU7tb47PZjfr3zQNueqJORs0EvsKPc
         v1UFe2rIU7KBvBH8FdAOUq4Y3NyImShy+CEbWzIbken85ZwO/3NWLTU4R3ujKR3FoyuS
         vbRw==
X-Forwarded-Encrypted: i=1; AJvYcCXmO709AuctR8PkgQ7CHQegx6MFLOLUnXNUbPNbZ1sxWbYpDkunGPe4NV61ffzofwOXFyERiAI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzeGAS7lCb1CYGcZxQRkGhn4S7MjNN/ukl1Nnpq4ZV2hyNMhLLI
	GFMZbvB7hgZjZpkExiup+gykPouVbRRFyVEXQAKNHwbfZSKz/vj+TgiLksCDRbsVj8K/2t2l1EJ
	9NCp+wA==
X-Google-Smtp-Source: AGHT+IHcnN2p00NsIVJ/Tco7clKqry81fiAhoeHRLb1kPa5FchoYCPasviVPCLtY7RbBfUFKTgyinTclnwgX
X-Received: from ejer10.prod.google.com ([2002:a17:906:9ca:b0:aa9:1d5b:da39])
 (user=qperret job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:9719:b0:aae:b259:ef63
 with SMTP id a640c23a62f3a-ab789b27dddmr445128366b.34.1738940081474; Fri, 07
 Feb 2025 06:54:41 -0800 (PST)
Date: Fri,  7 Feb 2025 14:54:36 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.502.g6dc24dfdaf-goog
Message-ID: <20250207145438.1333475-1-qperret@google.com>
Subject: [PATCH 0/2] Fixes for pKVM NP-guest support
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Vincent Donnefort <vdonnefort@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

Here are two patches to deal with a race between the handling of
permission faults and MMU notifiers with pKVM that I found by
inspection. Specifically, pKVM gets thoroughly confused when it doesn't
find a page mapped in its relax_perm path, while standard KVM deals
with that trivially thanks to the -EAGAIN special case in
user_mem_abort(). The second patch addresses the problem by simplifying
the implementation of multiple pKVM hypercalls, which also has the nice
side effect of improving locking by not taking the global host stage-2
lock as much.

Patches based on 6.14-rc1, tested in qemu on on Google Pixel 6.

Thanks!
Quentin

Quentin Perret (2):
  KVM: arm64: Improve error handling from check_host_shared_guest()
  KVM: arm64: Simplify np-guest hypercalls

 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 73 +++++++++++++++------------
 1 file changed, 40 insertions(+), 33 deletions(-)

-- 
2.48.1.502.g6dc24dfdaf-goog

