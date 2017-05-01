From: Jon Masters <jcm@jonmasters.org>
Subject: Re: [PATCH 0/2] arm64: Workaround for Thunder KVM hang issues.
Date: Mon, 1 May 2017 00:53:32 -0400
Message-ID: <1863d70c-eb50-1368-2a51-56110be0f352@jonmasters.org>
References: <20170424184250.667-1-david.daney@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20170424184250.667-1-david.daney@cavium.com>
Sender: linux-doc-owner@vger.kernel.org
To: David Daney <david.daney@cavium.com>, linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, Robert Richter <rrichter@cavium.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 04/24/2017 02:42 PM, David Daney wrote:
> We have discovered in rare circumstances, guest execution may result
> in host not receiving one or more interrupts.  This does not otherwise
> affect guest or host execution and/or isolation.

Thanks David. I have tested these and can confirm that a 4.11 machine
previously experiencing an issue has stable VMs with these.

Tested-by: Jon Masters <jcm@redhat.com>


