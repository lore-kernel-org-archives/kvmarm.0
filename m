Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39A319ABA3
	for <kvmarm@lists.linux.dev>; Mon, 30 Dec 2024 16:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735576119; cv=none; b=MWFdrtrVzQVNCJS+/OSXWiEJSaGEJOdmiTuYyHPOrzzRYdZ7tJ3V9W5EfiMA+xWsyW0VrPd59jPMvrcT5uuvl4OZRkl4UhciCrOKxb/zbfB6deig6S4YjOkTr7qiZv3yYq0YqBL89lsEel1TcPAVWuV+NyAgFJlrYTh6QxxtV5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735576119; c=relaxed/simple;
	bh=/w2wnR1V5WFpPPVzu2PyTowgh4NTjJoiqeSrVP8mzRE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vg5tojoTJUrkpLZyuSWa2KbwwTGFIpfr4sAYLwQHmWaNPybI51/wdQOBqhCTL4neXMrdXB1XOeWrrMLnjm/xP+9yAA9MzY2iT9G+T4i3F5M/7HFM23U8qcdF83xMb3YpcHRdNJMY8O67761T6lCFznUN1gRObu3+dP6Inrmwtnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CB239143D;
	Mon, 30 Dec 2024 08:29:02 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA64F3F673;
	Mon, 30 Dec 2024 08:28:33 -0800 (PST)
Date: Mon, 30 Dec 2024 16:28:30 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Andrew Jones <andrew.jones@linux.dev>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.linux.dev,
	nikos.nikoleris@arm.com, eric.auger@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2] arm64: Add basic MTE test
Message-ID: <Z3LKLvkLjId1SeTI@raptor>
References: <20241212103447.34593-1-vladimir.murzin@arm.com>
 <Z2lRk_NLHxDPvmrS@raptor>
 <0fc53bdf-f919-40b9-8530-d11593ec55f7@arm.com>
 <Z3K6FLG2qfwphAfS@raptor>
 <20241230-3c7d660ca38c9b390ec74b01@orel>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241230-3c7d660ca38c9b390ec74b01@orel>

Hi Drew,

On Mon, Dec 30, 2024 at 04:45:01PM +0100, Andrew Jones wrote:
> On Mon, Dec 30, 2024 at 03:19:48PM +0000, Alexandru Elisei wrote:
> ...
> > Interestingly though, when I try to run a test (either with ./run_tests.sh
> > mte-sync, or by trying out your example), I get this error:
> > 
> > qemu-system-aarch64: MTE requested, but not supported by the guest CPU
> > 
> > My guess is that's caused by kvm-unit-tests defaulting to cortex-a57 as the
> > model CPU. Changing the cpu to 'max' makes the test run. How are you getting
> > around this on your end?
> >
> 
> We can (and I think should) change to 'max' for the default model.

I think so too, something like this maybe?

diff --git a/configure b/configure
index 86cf1da36467..4babbd5f5e74 100755
--- a/configure
+++ b/configure
@@ -286,7 +286,7 @@ fi
 [ -z "$processor" ] && processor="$arch"

 if [ "$processor" = "arm64" ]; then
-    processor="cortex-a57"
+    processor="max"
 elif [ "$processor" = "arm" ]; then
     processor="cortex-a15"
 fi

Can't do the same for arm, because Makefile.arm passes the processor to
-mcpu and that causes a build error.


Thanks,
Alex
