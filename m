Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1E302C08C4;
	Wed, 18 Mar 2026 16:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773852819; cv=none; b=MKWLGwMMoZ7h1g6FDRFyikuCXXScGeNTVmp6qlXoVth/60J9073eVEnvrHV8tPRyT57ixBgw45F8MI3lCUL/mxL913y/fTaFkfcOiUMTY50QPpYqg0MN9J84KWGI4UpwV2aAawhTRPn3fop3NnQJQHSLxmRJPr7jYWU7Lt7hw0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773852819; c=relaxed/simple;
	bh=fsbipT/a8yrl3HeiZ2TAuTHLKHSdkAl3PK8pZp9xprY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ri/JCviLiTnplNYHdotMjKyhgojWumciBf52QGhBD0ULmH+H/uPhwdJxoEjaF035gihqV22NtyNJgtIweJY/sH8LcqKlErRWoLdkHEp4RB09yuYFFx7CC0kFHe86clycwEQfcY0yLKAiws8le0KSdYzNt/VPMdPCNlIThedRJN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1F4351BF7;
	Wed, 18 Mar 2026 09:53:31 -0700 (PDT)
Received: from [10.57.61.122] (unknown [10.57.61.122])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E4D173F778;
	Wed, 18 Mar 2026 09:53:29 -0700 (PDT)
Message-ID: <6e7cd05a-2859-4225-a50f-07d62f84568a@arm.com>
Date: Wed, 18 Mar 2026 16:53:25 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 00/48] arm64: Support for Arm CCA in KVM
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <20260318155413.793430-1-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

And for those who like to use shrinkwrap the following YAML config
should work on top of the 2025.12.0 tag to pull the various repos. Save
the below as e.g. cca-v13.yaml and follow the usual instructions in
cca-3world.yaml but refer to cca-v13.yaml instead.

---8<---
%YAML 1.2
---
concrete: true

layers:
  - cca-3world.yaml

build:
  linux:
    repo:
      revision: cca-host/v13

  kvmtool:
    repo:
      kvmtool:
        revision: cca/v11

  tfa:
    params:
      RMM_V1_COMPAT: 0
    repo:
      revision: master

  rmm:
    repo:
      revision: topics/rmm-v2.0-poc

