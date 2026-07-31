Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCF347D924;
	Fri, 31 Jul 2026 18:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785523915; cv=none; b=hVtAQ9JcHPyA8pczRoc6l/Vg6uYk8eSpBUpPCaEBNMIMJhs/2le/Ibo4kBc7pFLGL0WaBPJIXRF8RVHNfu08gK0nVgv0+M+HPy7Bvb2ZXi1EUX8yFfbyLrKm4Z0QGhaD76LsPfNY2geMpYRzp3J6q2T9Cme2MMyRrrshvmC8/5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785523915; c=relaxed/simple;
	bh=7TJnAcfmxn4SanH9hJhJwLu3abxkG114ZADx+2TkEy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q+4WU5N/RqiiQWQ44WHXJsBh8O9YlKUMVn+2gQsEimwL4XR5Yp9kryRKQRivG8NDruHqhlsgKCUqxEogGXtkv1dES9jgVoOT7t73ar0cSCgnwniz94uDQ4iXn1sBK2yqYbH4qsj1UUexdwhtQaHPu6xpu0aDmdduv0XM8Xd6Pi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARAiGENx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARAiGENx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852E11F00ADB;
	Fri, 31 Jul 2026 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785523913;
	bh=paag/QjyR3hsRmZHOMJCvt+dxx6Lz4I74syddlVYri0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ARAiGENxUVrM3FYXcjF2r9D99JtexGHlaMv6rcL7TffzIlPutZBi31fah6jH4iVuR
	 NUsbgxXjI6iP8BjwE0Dxa08BCEUygvrgWZM4ifNgp0haUdmKKm5ie6GOFLlFKxMl60
	 HFGHITZcRkWqffJvTqajT332OTf3TR68FZpiYh+eyUaY2YdIU9mRwwilcY7Czq+Cve
	 SCzXVlGkrYXsQqNULkYQIEg54PYryeK4c3Jq0X/JLnRugA5Hm06ASBwky45mv9RTsa
	 8Jf/Kprr+q2WMZZuzM/XS32GR8k1X+tdfZfTeWU/I6n7JXE+JEqrwLdsizCpqQWY7E
	 C7UZ9/cNUaLYg==
From: Oliver Upton <oupton@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>
Cc: Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Quentin Perret <qperret@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	Bradley Morgan <include@grrlz.net>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/7] KVM: arm64: pKVM stage-2 mapping and memcache fixes
Date: Fri, 31 Jul 2026 11:51:46 -0700
Message-ID: <178552142342.30097.13872328812800945380.b4-ty@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260717130317.1953574-1-fuad.tabba@linux.dev>
References: <20260717130317.1953574-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 17 Jul 2026 14:03:10 +0100, Fuad Tabba wrote:
> Changes since v4 [1]:
>   - Restored the permission-fault and dirty-logging memcache top-ups
>     that v4 dropped. Both fix real bugs.
>   - Patch 1 uses the anonymous bitfield encoding rather than the
>     open-coded mask and helpers. (Marc)
>   - Reshaped the permission-fault top-up to stage the full memcache
>     under pKVM, not just the mapping object. The object-only form still
>     returned -ENOMEM and tripped a WARN under the hypervisor's
>     unconditional min-pages check.
>   - Re-scoped the dirty-logging top-up to its generic, non-pKVM failure
>     mode, now that the permission-fault patch covers pKVM.
>   - Added three adjacent fixes found while going through the series, and
>     a selftest for the block transitions.
>   - Patches 1 and 3 keep Bradley's Signed-off-by from v3; my changes
>     to each are noted in a [tabba: ...] line.
> 
> [...]

Applied to next, thanks!

[1/7] KVM: arm64: Skip cache maintenance for non-cacheable pKVM mappings
      https://git.kernel.org/kvmarm/kvmarm/c/fff4eb33ffa0
[2/7] KVM: arm64: Top up the memcache for pKVM permission faults
      https://git.kernel.org/kvmarm/kvmarm/c/6bf0215c565e
[3/7] KVM: arm64: Top up stage-2 memcache for dirty logging faults
      https://git.kernel.org/kvmarm/kvmarm/c/56fd1fc526e6
[4/7] KVM: arm64: Skip pKVM stage-2 flush when FWB is enabled
      https://git.kernel.org/kvmarm/kvmarm/c/1feb9f6af895
[5/7] KVM: arm64: Don't WARN on pKVM stage-2 map failures
      https://git.kernel.org/kvmarm/kvmarm/c/c24322270169
[6/7] KVM: arm64: Don't advertise eager page splitting under pKVM
      https://git.kernel.org/kvmarm/kvmarm/c/c6f308b4d341
[7/7] KVM: arm64: selftests: Add stage-2 block transition test
      https://git.kernel.org/kvmarm/kvmarm/c/979ae12a2d09

--
Best,
Oliver
