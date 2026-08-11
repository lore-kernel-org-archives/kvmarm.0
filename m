Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C3242BE8A;
	Tue, 11 Aug 2026 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786442777; cv=none; b=GTaF19UVvO6uvyvLgOKRphgZOcjFMoodHLc5oywJcxvkHomRIxI9xW/9EpDljyRK8+5CSdSX8SvvV/7THZ+kWpI82IRZHqsOPVM0StrXcitzxHhb/C/XucPCx2ckA1xL1tQJmeU7xM9C4atyxEWEK+UNQ5sVzIorfOsoksT5TdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786442777; c=relaxed/simple;
	bh=ChzBs6eFPalqN+ZhvLBVhTuPnBWGf6rgJlj+9ZyX3BA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=O+2c08vlL6rl3vPEZaQf4kSjG4m9C0q8AD+p67cpbx1QbY7UdTBxjN4+4VN5rKrOUBBrgZfMvAjlOLUgvBrKIx+1NroTv5usGp1464VVcwENDUHUDwM/CPAMD9pnHR0lg3MvvK7nIRye/dtgM7uDLQymDftQL2kPP0l+eV0/nnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IeDAQ/7I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IeDAQ/7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A4701F000E9;
	Tue, 11 Aug 2026 10:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786442767;
	bh=uSgyWUQUOXkT3ixZAZs04DUNanjZeEZwO2+Fu0C0pOU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=IeDAQ/7Ish/yX0U8VJXoYoq4pKb7kydnqDGq/pZDcnkkADYcmeOfiyjd/6K4fk7IH
	 cD1VmCa377mV5C7Cj0vQzAc2AaiKI0TEGHX+U9dsQGnFq+puC2A9vz85sQwUiPpob+
	 br1klWfTZVFVWBlODjbrY3ZmJgoyU5EMYoE8/kHeBCejB6ke4jvIlEH5OBQMIZa5Pl
	 dwv9cup14TcREBxrxzhzwHaGzpYe3kbMzp1upF8cguLIWjEwooCTtLccIjuF7PRNOh
	 pQysWZPHJp3QJ/A7Uqv3HkfY9Gk5toww7/fsEf60j8QNVj4sYYJTNbMd7S/jJfTE8V
	 QXq9+WdeSKFUw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>
Cc: Tarun Sahu <tarunsahu@google.com>,  fuad.tabba@linux.dev,  Andrew Morton
 <akpm@linux-foundation.org>,  seanjc@google.com,  dmatlack@google.com,
  Shuah Khan <skhan@linuxfoundation.org>,  Jonathan Corbet
 <corbet@lwn.net>,  david@redhat.com,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Pratyush Yadav <pratyush@kernel.org>,
  sagis@google.com,  Paolo Bonzini <pbonzini@redhat.com>,  Mike Rapoport
 <rppt@kernel.org>,  Alexander Graf <graf@amazon.com>,
  linux-kselftest@vger.kernel.org,  andre.przywara@arm.com,
  michael.roth@amd.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  will@kernel.org,  vannapurve@google.com,  maz@kernel.org,
  fvdl@google.com,  kvm@vger.kernel.org,  oliver.upton@linux.dev,
  kvmarm@lists.linux.dev,  alexandru.elisei@arm.com,  skhawaja@google.com,
  aneesh.kumar@kernel.org,  linux-doc@vger.kernel.org,  David Hildenbrand
 <david@kernel.org>,  yan.y.zhao@intel.com,  kexec@lists.infradead.org,
  suzuki.poulose@arm.com
Subject: Re: [PATCH v4 11/11] KVM: selftests: Add guest_memfd_preservation_test
In-Reply-To: <CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
	(Ackerley Tng's message of "Thu, 30 Jul 2026 11:18:44 -0700")
References: <20260728121138.1103610-1-tarunsahu@google.com>
	<20260728121138.1103610-12-tarunsahu@google.com>
	<CAEvNRgEbS06snhyHznPSqxnUrdudVEKUuOpPwnU+AJATWFBRBA@mail.gmail.com>
Date: Tue, 11 Aug 2026 12:06:00 +0200
Message-ID: <2vxzy0ed3rav.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Thu, Jul 30 2026, Ackerley Tng wrote:

> Tarun Sahu <tarunsahu@google.com> writes:
>
>> Add guest_memfd_preservation_test to verify that KVM VM state and guest
>> memory backed by guest_memfd are preserved across a kexec reboot via Live
>> Update Orchestrator (LUO).
>>
>> This test includes multiple tests
>> - (A) Test to preserve non-guest_memfd, non-memfd which must fail (/dev/null)
>> - (B) Test to preserve guest_memfd with no INIT_SHARED flag which must fail
>> - (C) Test to allocate the guest_memfd memory after preservation because
>>   preservation makes the guest_memfd frozen. Which must fail as well.
>> - (D) Test to verify guest_memfd with INIT_SHARED flag preservation across
>>   kexec: Below is the details of stages in this test.
[...]
>> +++ b/tools/testing/selftests/kvm/guest_memfd_preservation_test.c
>> @@ -0,0 +1,357 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2026, Google LLC.
>> + *
>> + * Author: Tarun Sahu <tarunsahu@google.com>
>> + *
>> + * Test for VM and guest_memfd preservation across kexec (Live Update) via LUO.
>> + *
>> + * NOTE: This is a MANUAL test and is excluded from automated CI/testing
>> + * frameworks because Stage 1 daemonizes into the background to pin resources
>> + * and requires a human operator to manually trigger kexec before Stage 2
>> + * is executed. Running Stage 1 automatically would leak the background daemon
>> + * and cause CI runners to falsely interpret it as a passed test.
>> + *

I think this is fine as a first step but we really should automate
these.

We have some infrastructure to automate other live update tests across
both stages already by launching a VM under qemu and making the test
process as the init task. See tools/testing/selftests/kho/vmtest.sh. For
KVM tests you'd need the runner to be able to run nested VMs.

The script right now is pretty bare bones, but I really think we should
spend time improving it to the point where we can automate all our tests
using it.

>
> Usually there aren't many printfs in tests, but since this is a MANUAL
> test, maybe that's ok?
>
> Would like to know what Sean thinks of this, and printfs in general.

-- 
Regards,
Pratyush Yadav
