Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C7E40A95F
	for <kvmarm@lists.linux.dev>; Wed,  7 Oct 2026 06:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791355569; cv=none; b=HbkuTg1BpUoSDl9DYJCsj9jLOTf3NUG1nk7sjBVXwLeEAzjIyOUigrxuozZ4gM6idImlTKZfpb/wnbrt3p1tft1kiyIrxgqghDxtrNiNexqi+cq99QgRmuKUpL8VSySCui0Y99/dJDNwrEoHlFaHKh7xb9TNgWrh7ijwE9G5qE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791355569; c=relaxed/simple;
	bh=nWznkk9Fjq/D6EuRqmF/M6hW1RRZAYuOo1VRXMA0j/o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bxpS+8OlPst9VtTo3KEVbswkifFu+LUa43Yt5eRPlqdE9GiWeQxQD7FE89bZLyhuVNBkZpXLWfRxxBSHctSaMByr/u0w1Tu5etm9fExzzjaggjfM2a5Vsl2DEv0/6bDfpxf/EpQ+NyYDIn1R9En7L/f2h17IrzoH0qByuRTma9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ck5phDvg; arc=none smtp.client-ip=91.218.175.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ck5phDvg"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=nWznkk9Fjq/D6EuRqmF/M6hW1RRZAYuOo1VRXMA0j/o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791355566; v=1; x=1791960366;
 b=ck5phDvgykCb05cpCGyTHHBAiuqclB6TLZTdD25rMDcVemQCEur+Q5w2hGu6nef88aMTtyir
 BBNhrnfGkPTNsVjRVU61fLV1TNVk/K19zXCoRwzdp7UFAwybHolaFWcSWfYuLa6CaEbPnU1JvMo
 M53hdoIynv2O9u6L2cu/OTv0=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 478178a005110ff7;
	Wed, 07 Oct 2026 03:24:23 +0000
X-Mizu-Trace-ID: 478178a005110ff7
X-Migadu-Flow: FLOW_OUT
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5bcc04c71f5so4638e87.0
        for <kvmarm@lists.linux.dev>; Tue, 06 Oct 2026 20:24:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxblct7lPCMAFGUJ5jorX3d67+3yD9AGanY7aSI0jaTVzXisdXzVIj+3hO1D3Pj9eJqrL9Ci/c=@lists.linux.dev
X-Gm-Message-State: AFq9FYJzRJN/qzyHPlMw5H2FFYBz4BdKx7aBl9vuebSmUrFkIBX5mnUk
	hlNUPu6MYWpoUtgXKnWYlIfkWlveyHTszSC2SUBPgSKYe3yvdqC7I7uw3UPEuduCCNEOSXAeYc7
	hDrn1ZeGtGRRZKc2DjiVhCxVC3lsqJdmskLzVMiXu
X-Received: by 2002:a05:6512:33d3:b0:5bb:ff6f:b4bd with SMTP id
 2adb3069b0e04-5bcca66e395mr244231e87.14.1791343458771; Tue, 06 Oct 2026
 20:24:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260915084441.3846947-1-fuad.tabba@linux.dev>
In-Reply-To: <20260915084441.3846947-1-fuad.tabba@linux.dev>
From: Fuad Tabba <fuad.tabba@linux.dev>
Date: Wed, 7 Oct 2026 05:23:42 +0200
X-Gmail-Original-Message-ID: <CA+EHjTwqmQrLz5aDsCo1JFE2H6mz_dWDf=fkLsNup0cgenMCbg@mail.gmail.com>
X-Gm-Features: AclHuK_KSLUhfLp6Pl2z-XBsxbeEyfCpN3TL9UgSgX_CqN7OtwApebc1PcGPn3k
Message-ID: <CA+EHjTwqmQrLz5aDsCo1JFE2H6mz_dWDf=fkLsNup0cgenMCbg@mail.gmail.com>
Subject: Re: [PATCH 0/3] KVM: Replace VCPU_RUN with KVM_RUN in comments and docs
To: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, Will Deacon <will@kernel.org>, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

Gentle ping on this series.

Cheers,
/fuad
