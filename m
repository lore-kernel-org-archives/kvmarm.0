Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A1F311953
	for <kvmarm@lists.linux.dev>; Mon, 20 Oct 2025 12:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.197.217.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760962380; cv=none; b=V4Nt8dbyLAc2M55d7NMoGIjvE4tNa5o4T9s9d3YeDeVec6yEtxSoEXJbdcKx2BQrwgO/5tHJQBSvrIvsbOlMpQgo4kmgwRqUcLK5RweVU0BvDOOWiflW0EeekvbOZ6mUGhlp9Dcp4XJzXMocqVVr4RnjxEBvZuXM03f9FLQ4d/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760962380; c=relaxed/simple;
	bh=dahik2fjbYeAuSQncBFoEVv2d4q4dFGjf2TdTtpUg/c=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TeQKTMb8qLkEQDJTewV0Wf8veRxu3uCMzANe63Nf9F+lY+qjeSQiNq4r6vDJhEPlonEMCDhnhyiwJMSSuFAYfjnBvfnjugotwLEZSEnrdnWs60A9gm2ze+UXf1Nzoz6LRqBlvkX73LKRmfiNEml4uMb/S8im7dID26n9pkpQAEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de; spf=pass smtp.mailfrom=amazon.de; dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b=PsLPcAk2; arc=none smtp.client-ip=18.197.217.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.de header.i=@amazon.de header.b="PsLPcAk2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1760962378; x=1792498378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gT4c4sJrY+uRE80dfQnZ0+JjbvKqCsCY5BuNFNs0hp4=;
  b=PsLPcAk2a2GrKCm+mVCOAqFxm+0ChTvQqZcBZP2xxXIe7RVvg0EXSRHB
   K8mcg/GOsmFm3zKwf1T6vSHrhAyyXr8c1B34OCrrJRavVJl5WQcAZnqqO
   jGeB6gTcCcrFP2LuxHT65yfnCQ1VTAM2yu+2GEQulIGtcmVZbemFQFqdL
   P3dTeyY+f1QqpMHDBtZxLXIirTNmKwcWpAsC8bGj1KBBv8toXZ9P6P2Gl
   lccIlQKsndWGR3Yj0YCAoKKVpDlgx39FdiPW95kE/Kbnd+hOk2fs/oPUd
   KJAuZD0h0HUoyw7KxaK3xHFo4wEr4dAUPgNSgfWvN/BTGFqpdTsS3tDuK
   g==;
X-CSE-ConnectionGUID: paAvEk0fQZycm0Z2Ouoe9w==
X-CSE-MsgGUID: urA571EoRWOh9u8FI1m1cw==
X-IronPort-AV: E=Sophos;i="6.19,242,1754956800"; 
   d="scan'208";a="3869976"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 12:12:48 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:17685]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.169:2525] with esmtp (Farcaster)
 id d81a3bf9-5a3a-4933-b9f8-3d78ac7eca0f; Mon, 20 Oct 2025 12:12:48 +0000 (UTC)
X-Farcaster-Flow-ID: d81a3bf9-5a3a-4933-b9f8-3d78ac7eca0f
Received: from EX19D016EUA001.ant.amazon.com (10.252.50.245) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 20 Oct 2025 12:12:34 +0000
Received: from amazon.com (10.1.213.26) by EX19D016EUA001.ant.amazon.com
 (10.252.50.245) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20; Mon, 20 Oct 2025
 12:12:30 +0000
From: Maximilian Dittgen <mdittgen@amazon.de>
To: <maz@kernel.org>
CC: <epetron@amazon.de>, <kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kselftest@vger.kernel.org>,
	<mdittgen@amazon.com>, <mdittgen@amazon.de>, <nh-open-source@amazon.com>,
	<oliver.upton@linux.dev>, <pbonzini@redhat.com>, <shuah@kernel.org>
Subject: Re: [PATCH] KVM: selftests: fix ITS collection target addresses in vgic_lpi_stress
Date: Mon, 20 Oct 2025 14:12:20 +0200
Message-ID: <20251020121220.83972-1-mdittgen@amazon.de>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <86v7kdwj8u.wl-maz@kernel.org>
References: <20251017161918.40711-1-mdittgen@amazon.de> <86v7kdwj8u.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-ClientProxiedBy: EX19D037UWB004.ant.amazon.com (10.13.138.84) To
 EX19D016EUA001.ant.amazon.com (10.252.50.245)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, 17 Oct 2025 19:06:25 +0200,
Marc Zyngier <maz@kernel.org> wrote:
>
>	  * We use linear CPU numbers for redistributor addressing,
>	  * so GITS_TYPER.PTA is 0.
>
> It is not an address.

The issue is that its_encode_target in selftests is designed for
physical redistriubtor addresses (GITS_TYPER.PTA = 1) and thus
performs a right shift by 16 bits:

		its_mask_encode(&cmd->raw_cmd[2], target_addr >> 16, 51, 16);

When the vgic_lpi_stress selftest passes in a linear vCPU id as
the redistributor address (GITS_TYPER.PTA = 0 behavior),
The its_encode_target function shifts the CPU numbers 16 bits right,
functionally zeroing them.

We need to either:
- Align this specific selftest with GITS_TYPER.PTA = 0 and not use
    its_encode_target to encode the target vCPU id. Instead have a
    dedicated encode function for the use case without a bit shift.
- Align all selftests with GITS_TYPER.PTA = 0 and refactor
    its_encode_target to skip the bit shift altogether.
- Align selftests with GITS_TYPER.PTA = 1 and pass a redistributor
    address, not a vCPU id, into its_send_mapc_cmd().

Otherwise, the selftest's current behavior incorrectly maps all
collections to target vCPU 0.

Thanks,
Maximilian



Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597

