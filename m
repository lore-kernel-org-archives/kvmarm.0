Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D412A33A9C4
	for <kvmarm@lists.linux.dev>; Thu, 19 Feb 2026 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771511778; cv=none; b=dTiRrBVtinYlcy8IJZwcw5SRsnQVzaILkC56G8Cv27gVMXmLUgKNyUuUO5fep9Ffo92b/mSrtuA2QD3qnIN/r8VfEMvVFPiljNtNucyo6tu9zs5cdr8h/W5GzRblR6Cniq2xC73Fggnl2wdKIcX28R+dbKYGLT7YxDACPL9YLXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771511778; c=relaxed/simple;
	bh=8u4LSmIvd/C+3zPJ7zqMd0h+DXRGxy9OI+bxrxyF8gg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=efU3b2wF57oSHvEGC5WdcpI3myTzlUmOPFbJ4xeOwK1++euPk/f7WfbiiwVei1OV2mBPItah1vbP9xzHnhHAyRCR/DLcbdr6AoM90/4LBUOlb520KygKTNX6vClDq5sus8olJRT/rnLIernWVi4R9N2mNgSuVVkmxTQFYvlOSR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 691CA1A056C;
	Thu, 19 Feb 2026 14:36:08 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 7FEC32000D;
	Thu, 19 Feb 2026 14:36:04 +0000 (UTC)
Date: Thu, 19 Feb 2026 09:36:05 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 linux-trace-kernel@vger.kernel.org, maz@kernel.org, oliver.upton@linux.dev,
 joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
 kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
 jstultz@google.com, qperret@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, kernel-team@android.com,
 linux-kernel@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
 linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v11 15/30] tracing: selftests: Add trace remote tests
Message-ID: <20260219093605.192fdb48@gandalf.local.home>
In-Reply-To: <aYtUqOw8SdX7gqZT@google.com>
References: <20260131132848.254084-1-vdonnefort@google.com>
	<20260131132848.254084-16-vdonnefort@google.com>
	<20260205124208.2ed7cff8@gandalf.local.home>
	<aYtUqOw8SdX7gqZT@google.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 7FEC32000D
X-Stat-Signature: md7qtgedn665okqptay4z4jimakth6k8
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19TKj9CWzYjBj2NgmYOuR8HcgsdxJld1Oo=
X-HE-Tag: 1771511764-166707
X-HE-Meta: U2FsdGVkX1+y78bFA5Fh2e1MOsjN889PeyB/43QOfqL4DGisxGUCImil6IIXRs8fQJR5JZJFm/Zxf+B5pGcquvp6c8BKMqg0mUGcFRg1SoBJr/iNjYh/y+crvZDam9BCvS4tbHRGLeKyP/YRN78HcJBHPw3uz8tBRwhWhEpM/Ai3txTZW6rmFVeIlOIZ+kqWcmVUkXGJl8v4I3ACJIdwqGqBbNPdp5kDfmgun+cpiGem6Gj9q+/rrCRdF/OBjS2UsquDN+nQBOJe75u1Ftck2a9Pd8tpBvnPXAqeWLzz1eLVyax13XfwG6w0wtoPlB/uC4EdHvC0B4PTi9ocnf7xgSIoCxEqcxKu

On Tue, 10 Feb 2026 15:54:16 +0000
Vincent Donnefort <vdonnefort@google.com> wrote:

> Hum weird, I have changed it in v11 to 
> 
> echo 0 > /sys/devices/system/cpu/cpu$cpu/online || return 0
> 
> That doesn't work? Because I would simply stop the test there if we can't
> offline the CPU.


Yeah, I guess I was running the old tests. With the new tests I now have:

tools/testing/selftests/ftrace# ./ftracetest test.d/remotes/
=== Ftrace unit tests ===
[1] Test trace remote buffer size	[PASS]
[2] Test hypervisor trace buffer size	[UNSUPPORTED]
[3] Test hypervisor trace buffer reset	[UNSUPPORTED]
[4] Test hypervisor consuming trace read	[UNSUPPORTED]
[5] Test hypervisor non-consuming trace read	[UNSUPPORTED]
[6] Test hypervisor trace buffer unloading	[UNSUPPORTED]
[7] Test trace remote reset	[PASS]
[8] Test trace remote consuming read	[PASS]
[9] Test trace remote non-consuming read	[PASS]
[10] Test trace remote unloading	[PASS]


# of passed:  5
# of failed:  0
# of unresolved:  0
# of untested:  0
# of unsupported:  5
# of xfailed:  0
# of undefined(test bug):  0

-- Steve
