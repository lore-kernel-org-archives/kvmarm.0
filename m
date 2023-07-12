Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 849311F959;
	Wed, 12 Jul 2023 10:52:46 +0000 (UTC)
Received: from [2a02:8108:8980:2478:8cde:aa2c:f324:937e]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
	id 1qJXSa-0003DD-Al; Wed, 12 Jul 2023 12:52:40 +0200
Message-ID: <4da09faa-acb8-7262-b9ae-6cb327cff206@leemhuis.info>
Date: Wed, 12 Jul 2023 12:52:39 +0200
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3] KVM: arm64: Use BTI for nvhe
Content-Language: en-US, de-DE
To: Marc Zyngier <maz@kernel.org>,
 Linux regressions mailing list <regressions@lists.linux.dev>
Cc: Sudeep Holla <sudeep.holla@arm.com>, Mostafa Saleh <smostafa@google.com>,
 oliver.upton@linux.dev, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, tabba@google.com,
 qperret@google.com, will@kernel.org, catalin.marinas@arm.com,
 yuzenghui@huawei.com, suzuki.poulose@arm.com, james.morse@arm.com,
 bgardon@google.com, gshan@redhat.com
References: <20230530150845.2856828-1-smostafa@google.com>
 <20230704134136.a5znw4jupt5yp5kg@bogus>
 <55bffc21-5f19-765f-9dbc-1b565c880426@leemhuis.info>
 <864jm9wgsn.wl-maz@kernel.org>
From: "Linux regression tracking (Thorsten Leemhuis)"
 <regressions@leemhuis.info>
Reply-To: Linux regressions mailing list <regressions@lists.linux.dev>
In-Reply-To: <864jm9wgsn.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;regressions@leemhuis.info;1689159166;1ce672b6;
X-HE-SMSGID: 1qJXSa-0003DD-Al

On 12.07.23 12:44, Marc Zyngier wrote:
> On Wed, 12 Jul 2023 11:34:51 +0100,
> "Linux regression tracking (Thorsten Leemhuis)" <regressions@leemhuis.info> wrote:
>>
>> [CCing the regression list, as it should be in the loop for regressions:
>> https://docs.kernel.org/admin-guide/reporting-regressions.html]
>>
>> [TLDR: I'm adding this report to the list of tracked Linux kernel
>> regressions; the text you find below is based on a few templates
>> paragraphs you might have encountered already in similar form.
>> See link in footer if these mails annoy you.]
>>
>> On 04.07.23 15:41, Sudeep Holla wrote:
>>> On Tue, May 30, 2023 at 03:08:45PM +0000, Mostafa Saleh wrote:
>>>> CONFIG_ARM64_BTI_KERNEL compiles the kernel to support ARMv8.5-BTI.
>>>> However, the nvhe code doesn't make use of it as it doesn't map any
>>>> pages with Guarded Page(GP) bit.
>>> [...]
>>> I was chasing a bug in linux-next yesterday with protected nVHE(pKVM) and
>>> cpuidle enabled. The system fails to boot. I just bisected the issue to this
>>> patch and also saw this patch landed in the linus tree yesterday/today.
>>> Not sure if this is something to do with the fact that pKVM skips to
>>> __kvm_handle_stub_hvc in __host_hvc.
>>>
>>> Let me know if you want be to try something.
>>
>> Thanks for the report. Seems the fix is slow to progress.
> 
> It's not. See [1].
> 
> [1] https://lore.kernel.org/r/20230706152240.685684-1-smostafa@google.com

I'm aware of that fix, as one of the regzbot commands in the mail your
quoted pointed to that mail. But unless I'm missing something that fix
is now nearly a week old and not yet in -next. That from my point of
view makes it "slow to progress" and trackworthy.

Ciao, Thorsten
