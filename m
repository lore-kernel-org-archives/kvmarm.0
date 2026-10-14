Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685F5490BE5
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 07:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.139.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791963633; cv=none; b=e+GdlGNliL699tEEPio9gguHwtpmIcWI5gM5hWQIG87yunqnAzztzVq1p+4xMX4W3Xfx6bU460m4MgJ/3qdRfQDGsDYcC87j9goXNt0PwDXUGakfzfqCOGEvz5cfyuTXpUTccTVHT3txc1oDN1gGY6Bu4V2xJzmITnddp6LfVbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791963633; c=relaxed/simple;
	bh=8DNqwTDkyG/HzDA3Nlvx/HSSupKQoyoupiHktAu3TRQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=quK8B15QvNXZjzHfkoKcNPeF52N4cOzHuyqMpd6X+vQFatSmypS3Q3abxeS9Pq1gF/LZPX9Ot3ho6RW8l082FfFNWH31WTPXCRPZOenTs9m0B/DJvKTnj7CcvJ1DZoQA+wpZaID3SGj88+qWcLoFRrtHgqREquIfmb4pBW277Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com; spf=pass smtp.mailfrom=fujitsu.com; dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b=rNGTlFPJ; arc=none smtp.client-ip=68.232.139.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fujitsu.com header.i=@fujitsu.com header.b="rNGTlFPJ"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=fujitsu.com; i=@fujitsu.com; q=dns/txt; s=fj2;
  t=1791963631; x=1823499631;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=8DNqwTDkyG/HzDA3Nlvx/HSSupKQoyoupiHktAu3TRQ=;
  b=rNGTlFPJP2DPQ54s1T0uKGWc/9tVe67pAG4I7fgodWs+zun9k6x2nzF1
   n1p9B2RfzdUDmLfS41Hhlz4CaGmQJEETFoisYy0hSJ8xIlJT8gTAO3+UP
   fQqR/71bas+mgDv6LwGypsYdasZd6EMIIn4YQbcCS89U8HI6+5FeCaJ0A
   /GeNzxBvPwMucb3gFDBvNaCIPYYOO2GvVCo741bEgBdNn7CknfZ4g4Vb3
   omqC0Eq6zVRuNFqR+la2dFdprU2vUYJYfAGcWFfwTiQ0Bvo/KEReLudrJ
   utT/h4pT/3py5Ix9Dw4ngV0e0fchd058BhBkFs0b2gB8rRMxeU5XvEz10
   A==;
X-CSE-ConnectionGUID: GPPsU0g/TtefroxTvDrhFQ==
X-CSE-MsgGUID: v5TRJS9TQfOgUHBjZap8Xw==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="256362854"
X-IronPort-AV: E=Sophos;i="6.27,157,1786978800"; 
   d="scan'208";a="256362854"
Received: from gmgwnl01.global.fujitsu.com (HELO mgmgwnl01.global.fujitsu.com) ([52.143.17.124])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 16:40:23 +0900
Received: from az2nlsmgm1.o.css.fujitsu.com (unknown [10.150.26.203])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mgmgwnl01.global.fujitsu.com (Postfix) with ESMTPS id B5DB06759
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 07:40:23 +0000 (UTC)
Received: from az2uksmom4.o.css.fujitsu.com (unknown [10.151.22.204])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2nlsmgm1.o.css.fujitsu.com (Postfix) with ESMTPS id 6F58EC013CD
	for <kvmarm@lists.linux.dev>; Wed, 14 Oct 2026 07:40:23 +0000 (UTC)
Received: from sm-arm-grace07 (unknown [10.124.178.20])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by az2uksmom4.o.css.fujitsu.com (Postfix) with ESMTPS id 66FEA402666;
	Wed, 14 Oct 2026 07:40:18 +0000 (UTC)
Date: Wed, 14 Oct 2026 16:40:15 +0900
From: Itaru Kitayama <itaru.kitayama@fujitsu.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Oliver Upton <oupton@kernel.org>, Ben Horgan <ben.horgan@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: Re: [PATCH v8 0/3] KVM: selftests: arm64: Improve diagnostics from
 set_id_regs
Message-ID: <as8x38o9taXgKZym@sm-arm-grace07>
References: <20260929-kvm-arm64-set-id-regs-aarch64-v8-0-58aabe2c2fac@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260929-kvm-arm64-set-id-regs-aarch64-v8-0-58aabe2c2fac@kernel.org>

Hi Mark,
On Tue, Sep 29, 2026 at 05:16:51PM +0100, Mark Brown wrote:
> While debugging issues related to aarch64 only systems I ran into
> speedbumps due to the lack of detail in the results reported when the
> guest register read and reset value preservation tests were run, they
> generated an immediately fatal assert without indicating which register
> was being tested. Update these tests to non-fatally report a standard
> kselftest result per register, making it much easier to see what the
> problem being reported is.
> 
> A similar issue exists with the validation of the individual bitfields
> in registers due to the use of immediately fatal asserts. Update those
> asserts to be standard kselftest reports.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
> Changes in v8:
> - Convert another assert.
> - Link to v7: https://patch.msgid.link/20260901-kvm-arm64-set-id-regs-aarch64-v7-0-7b065b0bda9a@kernel.org
> 
> Changes in v7:
> - Rebase onto v7.3-rc1.
> - Link to v6: https://patch.msgid.link/20260719-kvm-arm64-set-id-regs-aarch64-v6-0-724287f5f108@kernel.org
> 
> Changes in v6:
> - Rebase onto v7.2-rc3.
> - Drop changes to handling of aarch32 related registers on 64 bit only
>   systems, an in kernel solution is preferred for those.

I’ve reproduced the set_id_regs failure under QEMU with kvm-arm.mode=nested on 
a host that supports AArch32. KVM advertises the NV-capable L1 vCPU as AArch64-only, 
but aa32_id_visibility() still permits the inner KVM to expose ID_DFR0_EL1.CopDbg = 0xa 
to the selftest vCPU. The test expects zero because it skips setting expected 
values for AArch32 ID registers.

In v6 you mentioned preferring an in-kernel solution. What did you have in mind, 
given that changing the value returned by GET_ONE_REG may affect the userspace ABI?

Thanks,
Itaru.

> - Use a define to count the non-test_regs registers.
> - Link to v5: https://patch.msgid.link/20260317-kvm-arm64-set-id-regs-aarch64-v5-0-a60f2b956e22@kernel.org
> 
> Changes in v5:
> - Rebase onto v7.0-rc1.
> - Link to v4: https://patch.msgid.link/20260106-kvm-arm64-set-id-regs-aarch64-v4-0-c7ef4551afb3@kernel.org
> 
> Changes in v4:
> - Correct check for 32 bit ID registers.
> - Link to v3: https://patch.msgid.link/20251219-kvm-arm64-set-id-regs-aarch64-v3-0-bfa474ec3218@kernel.org
> 
> Changes in v3:
> - Rebase onto v6.19-rc1.
> - Link to v2: https://patch.msgid.link/20251114-kvm-arm64-set-id-regs-aarch64-v2-0-672f214f41bf@kernel.org
> 
> Changes in v2:
> - Add a fix for spurious failures with 64 bit only guests.
> - Link to v1: https://patch.msgid.link/20251030-kvm-arm64-set-id-regs-aarch64-v1-0-96fe0d2b178e@kernel.org
> 
> ---
> Mark Brown (3):
>       KVM: selftests: arm64: Report set_id_reg reads of test registers as tests
>       KVM: selftests: arm64: Report register reset tests individually
>       KVM: selftests: arm64: Make set_id_regs bitfield validity checks non-fatal
> 
>  tools/testing/selftests/kvm/arm64/set_id_regs.c | 130 ++++++++++++++++++------
>  1 file changed, 98 insertions(+), 32 deletions(-)
> ---
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
> change-id: 20251028-kvm-arm64-set-id-regs-aarch64-ebb77969401c
> 
> Best regards,
> --  
> Mark Brown <broonie@kernel.org>
> 
