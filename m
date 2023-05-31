Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E742D1C11
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 10:41:37 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78F8B1042;
	Wed, 31 May 2023 03:42:20 -0700 (PDT)
Received: from [10.57.22.98] (unknown [10.57.22.98])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 811493F67D;
	Wed, 31 May 2023 03:41:34 -0700 (PDT)
Message-ID: <100579b3-649b-a57c-8639-edc6b22c7646@arm.com>
Date: Wed, 31 May 2023 11:41:33 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.0
Content-Language: en-GB
From: Nikos Nikoleris <nikos.nikoleris@arm.com>
Subject: [kvm-unit-tests] arm/arm64: psci_cpu_on_test failures with tcg
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Andrew Jones <andrew.jones@linux.dev>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I noticed that in the latest master the psci_cpu_on_test fails randomly 
for both arm and arm64 with tcg.

If I do:

$> for i in `seq 1 100`; do ACCEL=tcg MAX_SMP=8 ./run_tests.sh psci; 
done | grep FAIL

About 10 of the 100 runs fail for the arm and arm64 builds of the test. 
I had a look and I am not sure I understand why. When I run the test 
with kvm, I don't get any failures. Does anyone have an idea what could 
be causing this?

Thanks,

Nikos
