From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH 00/18] arm/arm64: add smp support
Date: Thu, 26 Feb 2015 14:54:45 +0100
Message-ID: <54EF25A5.1050402@redhat.com>
References: <1422815686-24591-1-git-send-email-drjones@redhat.com> <20150226113402.GA3143@cbox> <20150226135037.GF3023@hawk.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20150226135037.GF3023@hawk.usersys.redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Andrew Jones <drjones@redhat.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu



On 26/02/2015 14:50, Andrew Jones wrote:
> Yes, this sucks, as we can't tell the difference between qemu failing
> to run the test, and exiting with 1 vs. the test running, passing -
> exiting with (0 << 1) | 1. It's too bad debugexit didn't set a higher
> bit (like 5 or 6) to flag a "debug exit". Maybe it's not too late to
> change it? Paolo?

That would indeed have been a better idea. :(  I'm not sure it's worth
it because in theory exit codes of 1 should never happen in
kvm-unit-tests.  That said, it does suck when they happen due to a bug
in the harness.

Paolo
